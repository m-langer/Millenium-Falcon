
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "confusing" {
  name     = "confusing-resources"
  location = "West Europe"
}