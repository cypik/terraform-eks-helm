#####ingress-nginx
variable "ingres_name" {
  type        = string
  default     = ""
  description = "The name of the Ingress resource. Leave it empty if you don't want to create an Ingress."
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "clusterName" {
  type    = string
  default = ""
}

variable "ingress_chart" {
  type        = string
  description = "The name of the Ingress controller Helm chart to deploy."
  default     = ""
}

variable "ingress_enable" {
  type        = bool
  default     = false
  description = "Flag to enable or disable a feature. Set to true to enable, false to disable."
}

variable "ingress_repository" {
  type        = string
  default     = ""
  description = "The repository URL for the Ingress controller Helm chart. Leave it empty if using a locally available chart."
}

########### autoscaler ##########
variable "autoscaler_config" {
  type        = list(string)
  default     = []
  description = "Configuration settings for the autoscaler"
}

variable "autoscaler_enabled" {
  type        = bool
  default     = false
  description = "Enable or disable the autoscaler"
}

variable "autoscaler_name" {
  type        = string
  default     = ""
  description = "Name of the autoscaler"
}

variable "autoscaler_repository" {
  type        = string
  default     = ""
  description = "URL or name of the repository associated with the autoscaler"
}

variable "autoscaler_chart" {
  type        = string
  default     = ""
  description = "Name or path of the Helm chart used for the autoscaler"
}

variable "autoscaler_version" {
  type        = string
  default     = ""
  description = "Version of the autoscaler software to be deployed"
}

variable "autoscaler_namespace" {
  type        = string
  default     = ""
  description = "Kubernetes namespace where the autoscaler will be deployed"
}


######## albingress ##########
#variable "albingress_enabled" {
#  type = string
#  default = "true"
#}
#
#variable "albingress_name" {
#  type = string
#  default = ""
#}
#
#variable "albingress_chart" {
#  type = string
#  default = ""
#}
#
#variable "albingress_repository" {
#  type = string
#  default = ""
#}
#variable "albingress_namespace" {
#  type = string
#  default = "true"
#}