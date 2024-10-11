provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "example-resources-FK"
  location = "West Europe"
}
