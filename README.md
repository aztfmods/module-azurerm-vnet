![example workflow](https://github.com/aztfmods/module-azurerm-vnet/actions/workflows/validate.yml/badge.svg)

# Virtual Network

Terraform module which creates virtual network resources on Azure.

The below features are made available:

- [multiple](examples/multiple/main.tf) virtual network, subnet support
- [network security group](examples/nsg-rules/main.tf) support on each subnet with multiple rules
- [service endpoint](examples/service-endpoints/main.tf), [delegation](examples/delegations/main.tf) support
- [terratest](https://terratest.gruntwork.io) is used to validate different integrations
- [diagnostic](examples/diagnostic-settings/main.tf) logs integration
- [ddos protection plan](examples/ddos-protection/main.tf) integration

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "vnet" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      cidr          = ["10.18.0.0/16"]
      dns           = ["8.8.8.8","7.7.7.7"]
      subnets = {
        sn1 = { cidr = ["10.18.1.0/24"] }
      }
    }
  }
  depends_on = [module.global]
}
```

## Usage: endpoints

```hcl
module "vnet" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    vnet1 = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      cidr          = ["10.18.0.0/16"]
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          endpoints = [
            "Microsoft.Storage",
            "Microsoft.Sql"
          ]
        }
      }
    }
  }
  depends_on = [module.global]
}
```

## Usage: delegations

```hcl
module "vnet" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      cidr          = ["10.18.0.0/16"]
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          delegations = {
            databricks = { name = "Microsoft.Databricks/workspaces" }
          }
        }
      }
    }
  }
  depends_on = [module.global]
}
```

## Usage: nsg rules

```hcl
module "vnet" {
  source = "github.com/aztfmods/module-azurerm-vnet"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  vnets = {
    vnet1 = {
      cidr          = ["10.18.0.0/16"]
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      subnets = {
        sn1 = {
          cidr = ["10.18.1.0/24"]
          rules = [
            {name = "myhttps",priority = 100,direction = "Inbound",access = "Allow",protocol = "Tcp",source_port_range = "*",destination_port_range = "443",source_address_prefix = "10.151.1.0/24",destination_address_prefix = "*"},
            {name = "mysql",priority = 200,direction = "Inbound",access = "Allow",protocol = "Tcp",source_port_range = "*",destination_port_range = "3306",source_address_prefix = "10.0.0.0/24",destination_address_prefix = "*"}
          ]
        }
      }
    }
  }
  depends_on = [module.global]
}
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_dns_servers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/1.39.0/docs/data-sources/resource_group) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `vnets` | describes vnet related configuration | object | yes |
| `naming` | contains naming convention | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `vnets` | contains all vnets |
| `merged_ids` | contains all resource id's specified within the module |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-vnet/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-vnet/blob/main/LICENSE) for full details.

## Reference

- [Virtual Network Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/virtual-network/)
- [Virtual Network Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/virtual-network/)