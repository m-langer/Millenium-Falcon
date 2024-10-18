# Create a resource group
resource "azurerm_resource_group" "rg_bauer" {
  name     = "rg_bauer_3"
  location = "brazilsouth"

  tags = {
    owner = "andreas.bauer@redbull.com"
      }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet-bauer" {
  name                = "vnet-bauer"
  resource_group_name = azurerm_resource_group.rg_bauer.name
  location            = azurerm_resource_group.rg_bauer.location
  address_space       = ["10.10.10.0/24"]
 # dns_servers = "8.8.8.8"

tags = {
    owner = "andreas.bauer@redbull.com"
      }


}

  resource "azurerm_subnet" "sn-bauer" {
  name                 = "sn-bauer"
  resource_group_name  = azurerm_resource_group.rg_bauer.name
  virtual_network_name = azurerm_virtual_network.vnet-bauer.name
  address_prefixes     = ["10.10.10.0/25"]


}