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

Deploy a function app in consumption plan with git deployment enabled:

```
module "myfunction" {
    source              = "anoff/functionapp/azurerm"
    name                = "myfunction"
    location            = "westeurope"
    plan_type           = "consumption"
}

Outputs: git_url = myfunction.scm.azurewebsites:net:443/myfunction.git
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

Outputs: git_url =
```

Custom dedicated plan:

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
}
```

## License

[MIT](./LICENSE) © [Andreas Offenhaeuser](http://anoff.io)