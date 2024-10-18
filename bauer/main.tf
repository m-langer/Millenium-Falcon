# Create a resource group
resource "azurerm_resource_group" "rg_bauer" {
  name     = "rg_bauer_3"
  location = "brazilsouth"

  tags = {
    owner = "andreas.bauer@redbull.com"
      }
}