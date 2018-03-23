resource "azurerm_resource_group" "funcapp" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "funcapp" {
  name                     = "${var.storage_account_name == "" ? replace(var.function_app_name, "/[^a-z0-9]/", "") : var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.funcapp.name}"
  location                 = "${azurerm_resource_group.funcapp.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "funcapp" {
  name                = "${var.service_plan_name == "" ? replace(var.function_app_name, "/[^a-z0-9]/", "") : var.service_plan_name}"
  location            = "${azurerm_resource_group.funcapp.location}"
  resource_group_name = "${azurerm_resource_group.funcapp.name}"
  kind                = "${lower(var.plan_type) == "consumption" ? "FunctionApp" : var.plan_settings["kind"]}"

  sku {
    tier     = "${lower(var.plan_type) == "consumption" ? "Dynamic" : "Standard"}"
    size     = "${lower(var.plan_type) == "consumption" ? "Y1" : var.plan_settings["size"]}"
    capacity = "${lower(var.plan_type) == "consumption" ? 1 : var.plan_settings["capacity"]}"
  }
}

resource "azurerm_function_app" "funcapp" {
  name                      = "${var.function_app_name}"
  location                  = "${azurerm_resource_group.funcapp.location}"
  resource_group_name       = "${azurerm_resource_group.funcapp.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.funcapp.id}"
  storage_connection_string = "${azurerm_storage_account.funcapp.primary_connection_string}"
  client_affinity_enabled   = true

  #  version                   = "${var.version}"
  app_settings = "${var.app_settings}"

  site_config {
    always_on = "${lower(var.plan_type) == "consumption" ? false : var.always_on}"
  }

  # set up git deployment
  provisioner "local-exec" {
    command = "az functionapp deployment source config-local-git --ids ${azurerm_function_app.funcapp.id}"
  }
}
