provider "azurerm" {
  features {}
}

#----------------------------------------------------------------------------------------
# Resourcegroups
#----------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  for_each = var.vnets

  name     = each.value.resourcegroup
  location = each.value.location
}

#----------------------------------------------------------------------------------------
# Vnets
#----------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = "vnet-${var.env}-${each.key}"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = each.value.location
  address_space       = each.value.cidr
}

#----------------------------------------------------------------------------------------
# Subnets
#----------------------------------------------------------------------------------------

resource "azurerm_subnet" "subnets" {
  for_each = {
    for subnet in local.network_subnets : "${subnet.network_key}.${subnet.subnet_key}" => subnet
  }

  name                                           = each.value.subnet_name
  resource_group_name                            = each.value.rg_name
  virtual_network_name                           = each.value.virtual_network_name
  address_prefixes                               = each.value.address_prefixes
  service_endpoints                              = each.value.endpoints
  enforce_private_link_service_network_policies  = each.value.enforce_priv_link_service
  enforce_private_link_endpoint_network_policies = each.value.enforce_priv_link_endpoint

  dynamic "delegation" {
    for_each = each.value.delegations

    content {
      name = "delegation"

      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}