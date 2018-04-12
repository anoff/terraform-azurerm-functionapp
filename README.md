# Terraform module for Azure FunctionApp ⚡️

> Deploy a function app on Azure with minimal configuration

## Features

- Create resource group, storage account and service plan automatically
- Use `name` for all created resources by default, allowing custom values to be defined
- Automatically set up deployment via local git repo and expose as `git_url` output
- By default deactivate `client_affinity` and activate `always_on` (dedicated plans only)
- Single parameter to start app in consumption plan `plan_type = consumption`
- Customize all the things ✨

## Usage

> 🚨 Note: As Terraform and ARM do not natively support enabling local git deployment this module uses the `az` CLI for that. This means you need to have `az` installed and a valid login token when running Terraform. If you set `git_enabled = false` you do not need either.

Deploy a function app in consumption plan with git deployment enabled:

```
module "myfunction" {
    source              = "anoff/functionapp/azurerm"
    name                = "myfunction"
    location            = "westeurope"
    plan_type           = "consumption"
}

Outputs:
git_url = myfunction.scm.azurewebsites:net:443/myfunction.git
name    = myfunction
id      = /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Web/sites/myfunction
outbound_ip_addresses = 52.23.25.3,52.143.43.12
default_hostname = myfunction.azurewebsites.net
```

Use a dedicated app plan with default settings and disabled git deployment:

```
module "myfunction" {
    source              = "anoff/functionapp/azurerm"
    location            = "westeurope"
    resource_group_name = "myresourcegroup"
    name                = "myfunction"
    plan_type           = "dedicated"
    git_enabled         = false
}

Outputs:
git_url = 
name    = myfunction
id      = /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Web/sites/myfunction
outbound_ip_addresses = 52.23.25.3,52.143.43.12
default_hostname = myfunction.azurewebsites.net
```

Custom dedicated plan with web sockets:

```
module "myfunction" {
    source              = "anoff/functionapp/azurerm"
    location            = "westeurope"
    resource_group_name = "myresourcegroup"
    name                = "myfunction"
    plan_type           = "dedicated"
    plan_settings {
        kind     = "Windows" # Linux or Windows
        size     = "S3"
        capacity = 4
    }
    site_config {
        always_on          = true
        websockets_enabled = true
    }
}
```

## Changelog

### `v0.4.0`

- support `site_config` as variable, use this to set `always_on` property instead of the previous `var.always_on`

### `v0.3.0`

- add `connection_string` as input variable, see [terraform docs](https://www.terraform.io/docs/providers/azurerm/r/function_app.html#connection_string) for usage [#4](https://github.com/anoff/terraform-azurerm-functionapp/issues/4)

### `v0.2.0`

- additional outputs on the module [#2](https://github.com/anoff/terraform-azurerm-functionapp/issues/2)
- use `func_version` as module parameter to define function version [#3](https://github.com/anoff/terraform-azurerm-functionapp/issues/3)

### `v0.1.0`

- Set `accound_kind` to `StorageV2`
- Enable encryption at rest & `HTTPS` traffic only

## License

[MIT](./LICENSE) © [Andreas Offenhaeuser](http://anoff.io)