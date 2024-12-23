provider "aws" {
  region = local.region
}


locals {
  name           = "mahesh"
  environment    = "testing"
  region         = "eu-west-1"
  vpc_cidr_block = module.vpc.vpc_cidr_block

}

module "vpc" {
  source      = "cypik/vpc/aws"
  version     = "1.0.2"
  name        = "${local.name}-vpc"
  environment = local.environment
  cidr_block  = "10.10.0.0/16"
}

module "subnets" {
  source              = "cypik/subnet/aws"
  version             = "1.0.3"
  name                = "${local.name}-subnet"
  environment         = local.environment
  nat_gateway_enabled = true
  single_nat_gateway  = true
  availability_zones  = ["${local.region}a", "${local.region}b", "${local.region}c"]
  vpc_id              = module.vpc.vpc_id
  type                = "public-private"
  igw_id              = module.vpc.igw_id
  cidr_block          = local.vpc_cidr_block
  extra_public_tags = {
    "kubernetes.io/cluster/${module.eks.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                           = "1"
  }

  extra_private_tags = {
    "kubernetes.io/cluster/${module.eks.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                  = "1"
  }
}

module "ssh" {
  source      = "cypik/security-group/aws"
  version     = "1.0.1"
  name        = "${local.name}-ssh"
  environment = local.environment
  vpc_id      = module.vpc.vpc_id
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [local.vpc_cidr_block]
    description = "Allow ssh traffic."
    }
  ]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh outbound traffic."
  }]
}

module "http_https" {
  source      = "cypik/security-group/aws"
  version     = "1.0.1"
  name        = "${local.name}-http-https"
  environment = local.environment
  vpc_id      = module.vpc.vpc_id
  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [
    {
      rule_count  = 2
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow http traffic."
    },
    {
      rule_count  = 3
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow https traffic."
    }
  ]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count       = 1
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all traffic."
    }
  ]
}

module "kms" {
  source              = "cypik/kms/aws"
  version             = "1.0.2"
  name                = "${local.name}-kms"
  environment         = local.environment
  enabled             = true
  description         = "KMS key for EBS of EKS nodes"
  enable_key_rotation = false
  policy              = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_caller_identity" "current" {}


module "eks" {
  source      = "cypik/eks/aws"
  version     = "1.0.5"
  enabled     = true
  name        = local.name
  environment = local.environment

  # EKS
  kubernetes_version     = "1.31"
  endpoint_public_access = true
  # Networking
  vpc_id                            = module.vpc.vpc_id
  subnet_ids                        = module.subnets.private_subnet_id
  allowed_security_groups           = [module.ssh.security_group_id]
  eks_additional_security_group_ids = [module.ssh.security_group_id, module.http_https.security_group_id]
  allowed_cidr_blocks               = [local.vpc_cidr_block]

  managed_node_group_defaults = {
    subnet_ids                          = module.subnets.private_subnet_id
    nodes_additional_security_group_ids = [module.ssh.security_group_id]
    tags = {
      "kubernetes.io/cluster/${module.eks.cluster_name}" = "shared"
      "k8s.io/cluster/${module.eks.cluster_name}"        = "shared"
    }
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size = 64
          volume_type = "gp3"
          iops        = 3000
          throughput  = 150
          encrypted   = true
          kms_key_id  = module.kms.key_arn
        }
      }
    }
  }
  managed_node_group = {
    spot = {
      name           = "${module.eks.cluster_name}-spot"
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.medium"]
    }

    on_demand = {
      name                 = "${module.eks.cluster_name}-on-demand"
      capacity_type        = "ON_DEMAND"
      min_size             = 1
      max_size             = 2
      desired_size         = 1
      force_update_version = true
      instance_types       = ["t3.medium"]
    }
  }

  apply_config_map_aws_auth = false
  map_additional_iam_users = [
    {
      userarn  = "arn:aws:iam::123456789:user/cypik"
      username = "test"
      groups   = ["system:masters"]
    }
  ]
}

## Kubernetes provider configuration
data "aws_eks_cluster_auth" "this" {
  depends_on = [module.eks]
  name       = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  token                  = join("", data.aws_eks_cluster_auth.this.token)
}

resource "null_resource" "kubeconfig_setup" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig \
        --name ${module.eks.cluster_name} \
        --region ${local.region} \
        --kubeconfig ${path.module}/Kubeconfig
      echo "KUBECONFIG created at ${path.module}/Kubeconfig"
    EOT
  }

  # Ensure this runs after the EKS module is created
  depends_on = [module.eks]
}


provider "helm" {
  kubernetes {
    config_path = "${path.module}/Kubeconfig"
  }
}


module "ingress_nginx" {
  depends_on       = [null_resource.kubeconfig_setup]
  source           = "./../../"
  name             = "nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart_version    = "4.11.3"
  create_namespace = true
  set = [
    {
      name  = "image.tag"
      value = "v2.5.1"
    },
    {
      name  = "clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "vpcId"
      value = module.vpc.vpc_id
    },
    {
      name  = "region"
      value = "us-east-1"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.create"
      value = true
    },
    {
      name  = "replicaCount"
      value = "1"
    }
  ]
}