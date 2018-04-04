output "git_url" {
  description = "Git endpoint to deploy the function sourcecode to"
  value       = "${var.git_enabled ? join("", list(var.name, ".scm.azurewebsites.net:443/", var.name, ".git")) : ""}"
}

output "name" {
  description = "Function App name (identical with input parameter..for now)"
  value       = "${var.name}"
}

output "id" {
  description = "Function App unique ID"
  value       = "${azurerm_function_app.funcapp.id}"
}

output "outbound_ip_addresses" {
  description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12"
  value       = "${azurerm_function_app.funcapp.outbound_ip_addresses}"
}

output "default_hostname" {
  description = "Unique hostname to reach the Function App"
  value       = "${azurerm_function_app.funcapp.default_hostname}"
}
