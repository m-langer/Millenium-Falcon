resource "azurerm_resource_group" "confusing" {
  name     = "confusing-resources"
  location = "israelcentral"

  tags = {
      owner = "wayne.woodroffe@redbull.com"
  }
}

resource "azurerm_virtual_network" "confusing" {
  name                = "confusing-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.confusing.location
  resource_group_name = azurerm_resource_group.confusing.name
}

resource "azurerm_subnet" "confusing" {
  name                 = "confusing-subnet"
  resource_group_name  = azurerm_resource_group.confusing.name
  virtual_network_name = azurerm_virtual_network.confusing.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
}

}