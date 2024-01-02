#########    nginx-ingress  ###########
resource "helm_release" "ingress_nginx" {
  count           = var.ingress_enable == true ? 1 : 0
  name            = var.ingres_name
  repository      = var.ingress_repository
  chart           = var.ingress_chart
  namespace       = "kube-system"
  cleanup_on_fail = true

  set {
    name  = "image.tag"
    value = "v2.5.1"
  }
  set {
    name  = "clusterName"
    value = var.clusterName
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
  set {
    name  = "region"
    value = "us-east-1"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.create"
    value = true
  }
  set {
    name  = "replicaCount"
    value = "1"
  }
  wait = false
}



############ autoscaler ########
resource "helm_release" "autoscaler" {
  count            = var.autoscaler_enabled == true ? 1 : 0
  name             = var.autoscaler_name
  repository       = var.autoscaler_repository
  chart            = var.autoscaler_chart
  version          = var.autoscaler_version
  create_namespace = true
  namespace        = var.autoscaler_namespace
  values           = var.autoscaler_config
}

###--------------------------------------------------------alb-ingress---------------------------------------------------------
#data "kubectl_file_documents" "docs" {
#  content = file("./crds.yaml")
#}
#
#
#resource "helm_release" "albingress" {
#  count            = var.albingress_enabled ? 1 : 0
#  name             = var.albingress_name
#  chart            = var.albingress_chart
#  repository       = var.albingress_repository
#  #  namespace       = var.albingress_namespace
#  create_namespace = true
#  namespace        = "kube-system"
#  cleanup_on_fail  = true
#}
##
##  set {
##    name  = "image.tag"
##    value = "v2.5.1"
##  }
##  set {
##    name  = "clusterName"
##    value = var.clusterName
##  }
##  set {
##    name  = "vpcId"
##    value = var.vpc_id
##  }
##  set {
##    name  = "region"
##    value = "us-east-1"
##  }
##  set {
##    name  = "serviceAccount.name"
##    value = "aws-load-balancer-controller"
##  }
##  set {
##    name  = "serviceAccount.create"
##    value = true
##  }
##  set {
##    name  = "replicaCount"
##    value = "1"
##  }
##  wait       = false
##}