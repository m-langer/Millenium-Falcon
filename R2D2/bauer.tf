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

module "xxxxx" {
  source = "./modules/vm/"
  nic_name                      = "vm-nic-bauer"
  location = azurerm_resource_group.rg_bauer.location
  resource_group_name           = azurerm_resource_group.rg_bauer.name
  subnet_id                   = azurerm_subnet.sn-bauer.id
  # when using vnet module:
  // subnet_id                     = module.belka-vnet.subnet_id
  vm_name                       = "vm-bauer"
  vm_size                       = "Standard_DS1_v2"
  os_disk_name                  = "example-os-disk"
  image_publisher               = "Canonical"
  image_offer                   = "UbuntuServer"
  image_sku                     = "18.04-LTS"
  image_version                 = "latest"
  computer_name                 = "hostname"
  admin_username                = "bauer"
  admin_password                = "Password1234!"
  disable_password_authentication = false
}

