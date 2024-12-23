# Terraform-eks-helm

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

## Examples:

## Example: alb-controler
```hcl
module "alb-controler" {
  source          = "git::https://github.com/cypik/terraform-eks-helm.git?ref=v1.0.1"
  name            = "alb"
  chart           = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  chart_version   = "1.11.0"
  namespace       = "kube-system"
  cleanup_on_fail = true

  set = [
    {
      name  = "image.tag"
      value = "v2.6.2"
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
```

## Example: autoscaler

```hcl
module "autoscaler" {
  source           = "git::https://github.com/cypik/terraform-eks-helm.git?ref=v1.0.1"
  name             = "autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  chart_version    = "9.43.2"
  namespace        = "autoscaler"
  create_namespace = true
  set = [
    {
      name  = "awsRegion"
      value = "us-east-1"
    },
    {
      name  = "autoscalingGroups[0].name"
      value = data.aws_autoscaling_groups.groups.names[0]
    },
    {
      name  = "autoscalingGroups[0].maxSize"
      value = 4
    },
    {
      name  = "autoscalingGroups[0].minSize"
      value = 2
    },
    {
      name  = "autoscalingGroups[1].name"
      value = data.aws_autoscaling_groups.groups.names[0]
    },
    {
      name  = "autoscalingGroups[1].                                                                            "
      value = 3
    },
    {
      name  = "autoscalingGroups[1].minSize"
      value = 1
    },
  ]
}
```

## Example: ingress_nginx

```hcl
module "ingress_nginx" {
  source           = "git::https://github.com/cypik/terraform-eks-helm.git?ref=v1.0.1"
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
```

## Example
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-helm-nginx-ingress/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-helm-nginx-ingress/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.11.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.3.0, < 3.0.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.10.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.10.0, < 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.3.0, < 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false. | `bool` | `false` | no |
| <a name="input_chart"></a> [chart](#input\_chart) | Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if repository is specified. It is also possible to use the <repository>/<chart> format here if you are running Terraform on a system that the repository has been added to with helm repo add but this is not recommended. | `string` | `""` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Specify the exact chart version to install. If this is not specified, the latest version is installed. helm\_release will not automatically grab the latest release, version must explicitly upgraded when upgrading an installed chart. | `string` | `""` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not yet exist. Defaults to false. | `bool` | `false` | no |
| <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update) | Runs helm dependency update before installing the chart. Defaults to false. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Set release description attribute (visible in the history). | `string` | `null` | no |
| <a name="input_devel"></a> [devel](#input\_devel) | Use chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored. | `string` | `null` | no |
| <a name="input_disable_openapi_validation"></a> [disable\_openapi\_validation](#input\_disable\_openapi\_validation) | If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to false. | `bool` | `false` | no |
| <a name="input_disable_webhooks"></a> [disable\_webhooks](#input\_disable\_webhooks) | Prevent hooks from running. Defaults to false. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable or disable the resources | `string` | `true` | no |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | Force resource update through delete/recreate if needed. Defaults to false. | `bool` | `false` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | Location of public keys used for verification. Used only if verify is true. Defaults to /.gnupg/pubring.gpg in the location set by home | `string` | `null` | no |
| <a name="input_lint"></a> [lint](#input\_lint) | Run the helm chart linter during the plan. Defaults to false. | `bool` | `false` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | Maximum number of release versions stored per release. Defaults to 0 (no limit). | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | Release name. The length must not be longer than 53 characters. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the release into. Defaults to default. | `string` | `""` | no |
| <a name="input_pass_credentials"></a> [pass\_credentials](#input\_pass\_credentials) | Pass credentials to all domains. Defaults to false. | `bool` | `false` | no |
| <a name="input_postrender"></a> [postrender](#input\_postrender) | Configure a command to run after helm renders the manifest which can alter the manifest contents. | `list(any)` | `[]` | no |
| <a name="input_recreate_pods"></a> [recreate\_pods](#input\_recreate\_pods) | Perform pods restart during upgrade/rollback. Defaults to false. | `bool` | `false` | no |
| <a name="input_render_subchart_notes"></a> [render\_subchart\_notes](#input\_render\_subchart\_notes) | If set, render subchart notes along with the parent. Defaults to true. | `bool` | `true` | no |
| <a name="input_replace"></a> [replace](#input\_replace) | Re-use the given name, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to false. | `bool` | `false` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository URL where to locate the requested chart. | `string` | `""` | no |
| <a name="input_repository_config"></a> [repository\_config](#input\_repository\_config) | repository configuration | `map(any)` | `{}` | no |
| <a name="input_reset_values"></a> [reset\_values](#input\_reset\_values) | When upgrading, reset the values to the ones built into the chart. Defaults to false. | `bool` | `false` | no |
| <a name="input_reuse_values"></a> [reuse\_values](#input\_reuse\_values) | When upgrading, reuse the last release's values and merge in any overrides. If 'reset\_values' is specified, this is ignored. Defaults to false. | `bool` | `false` | no |
| <a name="input_set"></a> [set](#input\_set) | Value block with custom values to be merged with the values yaml. | `list(any)` | `[]` | no |
| <a name="input_set_list"></a> [set\_list](#input\_set\_list) | Value block with list of custom values to be merged with the values yaml. | `list(any)` | `[]` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff. | `list(any)` | `[]` | no |
| <a name="input_skip_crds"></a> [skip\_crds](#input\_skip\_crds) | If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to false. | `bool` | `false` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds. | `number` | `300` | no |
| <a name="input_values"></a> [values](#input\_values) | List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple -f options. | `list(string)` | `[]` | no |
| <a name="input_verify"></a> [verify](#input\_verify) | Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. For more information see the Helm Documentation. Defaults to false. | `bool` | `false` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true. | `bool` | `true` | no |
| <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs) | f wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as timeout. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chart"></a> [chart](#output\_chart) | Chart name to be installed |
| <a name="output_manifest"></a> [manifest](#output\_manifest) | The rendered manifest of the release as JSON. Enable the manifest experiment to use this feature. |
| <a name="output_name"></a> [name](#output\_name) | Release name |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace to install the release into |
| <a name="output_repository"></a> [repository](#output\_repository) | Repository URL where to locate the requested chart |
| <a name="output_status"></a> [status](#output\_status) | Status of the release. |
| <a name="output_values"></a> [values](#output\_values) | The compounded values from values and set* attributes. |
| <a name="output_version"></a> [version](#output\_version) | A SemVer 2 conformant version string of the chart. |
<!-- END_TF_DOCS -->