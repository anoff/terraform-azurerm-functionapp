# Terraform module for Azure FunctionApp ⚡️

> 

## Usage

```
module "myfunction" {
    source              = "anoff/functionapp/azurerm"
    location            = "westeurope"
    resource_group_name = "myresourcegroup"
    function_app_name   = "myfunction"
    plan_type           = "consumption"
}
```

## License

[MIT](./LICENSE) © [Andreas Offenhaeuser](http://anoff.io)