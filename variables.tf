# ###
# required values
# ###

variable "location" {
  description = "Region where the resources are created."
}

variable "name" {
  description = "The name of the function app"
}

variable "plan_type" {
  description = "What kind of plan to use (dedicated or consumption)"
}

# ###
# optional values
# ###

variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created, default = $function_app_name"
  default     = ""
}

variable "plan_settings" {
  type        = "map"
  description = "Definition of the dedicated plan to use, default = Linux 1x S1"

  default = {
    kind     = "Linux" # Linux or Windows
    size     = "S1"
    capacity = 1
  }
}

variable "storage_account_name" {
  description = "The name of the storage account for WebJobs, default = $function_app_name"
  default     = ""
}

variable "service_plan_name" {
  description = "The name of the App Service Plan, default = $function_app_name"
  default     = ""
}

variable "func_version" {
  description = "The runtime version associated with the Function App. Possible values are ~1 and beta. Defaults to ~1."
  default     = "~1"
}

variable "app_settings" {
  description = "A key-value pair of App Settings."
  default     = {}
}

variable "always_on" {
  description = "Keep the function always_on, default = true"
  default     = true
}

variable "client_affinity_enabled" {
  description = ""
  default     = false
}

variable "git_enabled" {
  description = "Setup git deployment, default = true"
  default     = true
}
