# Create a resource group
resource "azurerm_resource_group" "rg_bauer" {
  name     = "rg_bauer_3"
  location = "brazilsouth"

  tags = {
    owner = "andreas.bauer@redbull.com"
      }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "vnet-bauer"
  resource_group_name = azurerm_resource_group.rg_bauer.name
  location            = azurerm_resource_group.rg_bauer.location
  address_space       = ["10.10.10.0/24"]
  
tags = {
    owner = "andreas.bauer2@redbull.com"
      }

}