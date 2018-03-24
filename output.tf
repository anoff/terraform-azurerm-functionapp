output "git_url" {
  value = "${var.git_enabled ? join("", list(var.function_app_name, ".scm.azurewebsites.net:443/", var.function_app_name, ".git")) : ""}"
}
