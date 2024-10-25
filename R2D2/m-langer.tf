resource "azurerm_resource_group" "m-langer-rg" {
  name     = "m-langer"
  location = "canadaeast"
  tags = {
    owner = "moritz.langer@redbull.com"
  }
}

# creat a virtual network
resource "azurerm_virtual_network" "m-langer-vnet" {
  name                = "m-langer-vnet"
  resource_group_name = azurerm_resource_group.m-langer-rg.name
  location            = azurerm_resource_group.m-langer-rg.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    owner = "moritz.langer@redbull.com"
  }
}
# create a subnet
resource "azurerm_subnet" "m-langer-subnet" {
  name                 = "m-langer-subnet"
  resource_group_name  = azurerm_resource_group.m-langer-rg.name
  virtual_network_name = azurerm_virtual_network.m-langer-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "m-langer-vm" {
  source = "./modules/vm"
  nic_name                      = "vm-nic"
  location                      = azurerm_resource_group.m-langer-rg.location
  resource_group_name           = azurerm_resource_group.m-langer-rg.name
  subnet_id                     = azurerm_subnet.m-langer-subnet.id
  # when using vnet module:
  // subnet_id                     = module.belka-vnet.subnet_id
  vm_name                       = "vm"
  vm_size                       = "Standard_F2"
  os_disk_name                  = "example-os-disk"
  image_publisher               = "Canonical"
  image_offer                   = "UbuntuServer"
  image_sku                     = "18.04-LTS"
  image_version                 = "latest"
  computer_name                 = "hostname"
  admin_username                = "adminuser"
  admin_password                = "PW123PE456!?"
  disable_password_authentication = false
}