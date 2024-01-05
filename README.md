# Terraform-aws-eks

# AWS Infrastructure Provisioning with Terraform

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This module is basically combination of Terraform open source and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.
## Usage
To use this module, you can include it in your Terraform configuration. Here's an example of how to use it:

## Example: ingress_nginx
```hcl
module "ingress_nginx" {
source                  = "git::https://github.com/cypik/terraform-helm-nginx-ingress.git?ref=v1.0.0"
ingress_enable          = true
ingres_name             = "testing"
ingress_chart           = "ingress-nginx"
ingress_repository      = "https://kubernetes.github.io/ingress-nginx"
ingress_nginx_namespace = "ingress-nginx"
}
```

## Example: autoscaler
```hcl
  module "autoscaler" {
  source                = "git::https://github.com/cypik/terraform-helm-autoscaler.git?ref=v1.0.0"
  autoscaler_enabled    = true
  autoscaler_name       = "autoscaler"
  autoscaler_repository = "https://kubernetes.github.io/autoscaler"
  autoscaler_chart      = "cluster-autoscaler"
  autoscaler_version    = "9.34.0"
  autoscaler_namespace  = "kube-system"
  depends_on            = [module.eks.cluster_id]
}
```
## Module Inputs
- `name`  : Release name. The length must not be longer than 53 characters.
- `chart` : Chart name to be installed.
- `repository` : Repository URL where to locate the requested chart.
- `create_namespace`:  lag to control the cluster_enabled creation.
For security group settings, you can configure the ingress and egress rules using variables like:

## Module Outputs
- `name` : Name is the name of the release.
- `chart` : The name of the chart.
- `namespace` :  Namespace is the kubernetes namespace of the release.
- `version` : A SemVer 2 conformant version string of the chart.
## Example
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-helm-nginx-ingress/tree/master/example) directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/cypik/terraform-helm-nginx-ingress/blob/master/LICENSE) file for details.
