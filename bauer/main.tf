# Create a resource group
resource "azurerm_resource_group" "rg_bauer" {
  name     = "rg_bauer"
  location = "West Europe"
}