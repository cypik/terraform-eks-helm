##nginx-ingress
output "ingres_name" {
  value       = join("", helm_release.ingress_nginx[*].name)
  description = "Release name"
}

output "ingress_chart" {
  value       = join("", helm_release.ingress_nginx[*].chart)
  description = "Chart name to be installed"
}

output "ingress_repository" {
  value       = join("", helm_release.ingress_nginx[*].repository)
  description = "Repository URL where to locate the requested chart"
}

output "ingress_nginx_namespace" {
  value       = join("", helm_release.ingress_nginx[*].namespace)
  description = "The namespace to install the release into"
}

#### autoscaler ######
output "autoscaler_name" {
  value       = join("", helm_release.autoscaler[*].name)
  description = "Release name"
}

output "autoscaler_chart" {
  value       = join("", helm_release.autoscaler[*].chart)
  description = "Chart name to be installed"
}

output "autoscaler_repository" {
  value       = join("", helm_release.autoscaler[*].repository)
  description = "Repository URL where to locate the requested chart"
}

output "autoscaler_namespace" {
  value       = join("", helm_release.autoscaler[*].namespace)
  description = "The namespace to install the release into"
}
####
output "autoscaler_version" {
  value       = join("", helm_release.autoscaler[*].namespace)
  description = "The namespace to install the release into"
}
##### albingress #####
#output "albingress_name" {
#  value       = join("", helm_release.albingress[*].name)
#   description = "Release name"
#}
#
#output "albingress_chart" {
#  value = join("", helm_release.albingress[*].chart)
#   description = "Chart name to be installed"
#}
#
#output "albingress_repository" {
#  value = join("", helm_release.albingress[*].repository)
#  description = "Repository URL where to locate the requested chart"
#}
#
#output "albingress_namespace" {
#  value = join("", helm_release.albingress[*].namespace)
#  description = "The namespace to install the release into"
#
#}