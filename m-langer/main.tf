resource "azurerm_resource_group" "m-langer" {
  name     = "m-langer"
  location = "canadaeast"
  tags = {
    owner = "moritz.langer@redbull.com"
  }
}