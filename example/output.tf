##nginx-ingress
output "ingres_name" {
  value       = module.ingress_nginx[*].ingres_name
  description = "Release name"
}

output "ingress_chart" {
  value       = module.ingress_nginx[*].ingress_chart
  description = "Chart name to be installed"
}

output "ingress_repository" {
  value       = module.ingress_nginx[*].ingress_repository
  description = "Repository URL where to locate the requested chart"
}

output "ingress_nginx_namespace" {
  value       = module.ingress_nginx[*].ingress_nginx_namespace
  description = "The namespace to install the release into"
}

###  autoscaler #########

output "autoscaler_name" {
  value       = module.autoscaler[*].autoscaler_name
  description = "Release name"
}

output "autoscaler_chart" {
  value       = module.autoscaler[*].autoscaler_chart
  description = "Chart name to be installed"
}

output "autoscaler_repository" {
  value       = module.autoscaler[*].autoscaler_repository
  description = "Repository URL where to locate the requested chart"
}

output "autoscaler_namespace" {
  value       = module.autoscaler[*].autoscaler_namespace
  description = "The namespace to install the release into"
}

output "autoscaler_version" {
  value       = module.autoscaler[*].autoscaler_version
  description = "The namespace to install the release into"
}

###### albingress #######
#
#output "albingress_name" {
#  value = module.albingress[*].ingres_name
#  description =""
#}
#
#output "albingress_chart" {
#  value = module.albingress[*].ingress_chart
#  description =""
#}
#
#output "albingressr_repository" {
#  value = module.albingress[*].ingress_repository
#  description = ""
#}
#
#output "albingress_namespace" {
#  value = module.albingress
#  description = ""
#}
