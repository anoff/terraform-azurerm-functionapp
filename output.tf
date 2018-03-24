output "git_url" {
  value = "${var.git_enabled ? join("", list(var.name, ".scm.azurewebsites.net:443/", var.name, ".git")) : ""}"
}
