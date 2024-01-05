output "manifest" {
  value       = helm_release.helm[*].manifest
  description = "The rendered manifest of the release as JSON. Enable the manifest experiment to use this feature."
}

output "status" {
  value       = join("", helm_release.helm[*].status)
  description = "Status of the release."
}
output "name" {
  value       = join("", helm_release.helm[*].name)
  description = "Release name"
}

output "chart" {
  value       = join("", helm_release.helm[*].chart)
  description = "Chart name to be installed"
}

output "repository" {
  value       = join("", helm_release.helm[*].repository)
  description = "Repository URL where to locate the requested chart"
}

output "namespace" {
  value       = join("", helm_release.helm[*].namespace)
  description = "The namespace to install the release into"
}

output "version" {
  value       = join("", helm_release.helm[*].version)
  description = "A SemVer 2 conformant version string of the chart."
}

#output "revision" {
#  value = join("", helm_release.helm[*].revision)
#  description = "Version is an int32 which represents the version of the release."
#}
#
#output "app_version" {
#  value = join("", helm_release.helm[*].app_version)
#  description = "The version number of the application being deployed."
#}

#output "values" {
#  value = join("", helm_release.helm[*].values)
#  description = "The compounded values from values and set* attributes."
#}