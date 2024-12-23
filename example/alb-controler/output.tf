output "alb_controler_name" {
  value       = module.alb_controler[*].name
  description = "Release name"
}

output "alb_controler_chart" {
  value       = module.alb_controler[*].chart
  description = "Chart name to be installed"
}

output "alb_controlerr_repository" {
  value       = module.alb_controler[*].repository
  description = "Repository URL where to locate the requested chart"
}