provider "azurerm" {
  version = ">= 1.3.0"
}

terraform {
  required_version = ">= 0.11.0"
}

resource "azurerm_resource_group" "funcapp" {
  name     = "${var.resource_group_name == "" ? replace(var.name, "/[^a-z0-9]/", "") : var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "funcapp" {
  name                      = "${var.storage_account_name == "" ? replace(var.name, "/[^a-z0-9]/", "") : var.storage_account_name}"
  resource_group_name       = "${azurerm_resource_group.funcapp.name}"
  location                  = "${azurerm_resource_group.funcapp.location}"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
}

resource "azurerm_app_service_plan" "funcapp" {
  name                = "${var.service_plan_name == "" ? replace(var.name, "/[^a-z0-9]/", "") : var.service_plan_name}"
  location            = "${azurerm_resource_group.funcapp.location}"
  resource_group_name = "${azurerm_resource_group.funcapp.name}"
  kind                = "${lower(var.plan_type) == "consumption" ? "FunctionApp" : var.plan_settings["kind"]}"

  sku {
    tier     = "${lower(var.plan_type) == "consumption" ? "Dynamic" : "Standard"}"
    size     = "${lower(var.plan_type) == "consumption" ? "Y1" : var.plan_settings["size"]}"
    capacity = "${lower(var.plan_type) == "consumption" ? 0 : var.plan_settings["capacity"]}"
  }
}

resource "azurerm_function_app" "funcapp" {
  name                      = "${var.name}"
  location                  = "${azurerm_resource_group.funcapp.location}"
  resource_group_name       = "${azurerm_resource_group.funcapp.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.funcapp.id}"
  storage_connection_string = "${azurerm_storage_account.funcapp.primary_connection_string}"
  client_affinity_enabled   = "${var.client_affinity_enabled}"
  version                   = "${var.version}"
  app_settings              = "${var.app_settings}"

  site_config {
    always_on = "${lower(var.plan_type) == "consumption" ? false : var.always_on}"
  }

  # set up git deployment
  provisioner "local-exec" {
    command = "${var.git_enabled ? join("", list("az functionapp deployment source config-local-git --ids ", azurerm_function_app.funcapp.id)) : "true"}"
  }
}
