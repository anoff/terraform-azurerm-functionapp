output "git_url" {
  description = "Git endpoint to deploy the function sourcecode to"
  value       = "${var.git_enabled ? join("", list(var.name, ".scm.azurewebsites.net:443/", var.name, ".git")) : ""}"
}
