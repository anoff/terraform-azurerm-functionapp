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
  description = "Definition of the dedicated plan to use"

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
  description = "The runtime version associated with the Function App. Possible values are `~1` and `beta`"
  default     = "~1"
}

variable "app_settings" {
  description = "A key-value pair of App Settings"
  default     = {}
}

variable "connection_string" {
  description = "A block containing connection string definitions, see https://www.terraform.io/docs/providers/azurerm/r/function_app.html#connection_string"
  default     = []
}

variable "client_affinity_enabled" {
  description = "Enable client affinity a.k.a. sticky sessions"
  default     = false
}

variable "git_enabled" {
  description = "Set deployment mode to local git"
  default     = true
}

variable "site_config" {
  description = "A key-value pair for Site Config"
  type        = "list"

  default = [{
    always_on = true
  }]
}

// turn always on off in case of consumption plan while preserving custom site_config parameters
locals {
  site_config = ["${merge(
    var.site_config[0],
    map("always_on", lower(var.plan_type) == "consumption" ? false : lookup(var.site_config[0], "always_on"))
    )}"]
}
