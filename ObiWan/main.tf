resource "azurerm_resource_group" "confusing" {
  name     = "confusing-resources"
  location = "israelcentral"

  tags = {
      owner = "wayne.woodroffe@redbull.com"
  }
}