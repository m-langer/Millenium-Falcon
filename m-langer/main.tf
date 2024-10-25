resource "azurerm_resource_group" "m-langer" {
  name     = "m-langer"
  location = "canadaeast"
  tags = {
    owner = "moritz.langer@redbull.com"
  }
}

# creat a virtual network
resource "azurerm_virtual_network" "m-langer" {
  name                = "m-langer-vnet"
  resource_group_name = azurerm_resource_group.m-langer.name
  location            = azurerm_resource_group.m-langer.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    owner = "moritz.langer@redbull.com"
  }
}
# create a subnet
resource "azurerm_subnet" "m-langer" {
  name                 = "m-langer-subnet"
  resource_group_name  = azurerm_resource_group.m-langer.name
  virtual_network_name = azurerm_virtual_network.m-langer.name
  address_prefixes     = ["10.0.1.0/24"]
}

# add a network interface
resource "azurerm_network_interface" "m-langer" {
  name                = "m-langer-nic"
  resource_group_name = azurerm_resource_group.m-langer.name
  location            = azurerm_resource_group.m-langer.location

  ip_configuration {
    name                          = "m-langer-ipconfig"
    subnet_id                     = azurerm_subnet.m-langer.id
    private_ip_address_allocation = "Dynamic"
  }
}

# add a virtual machine
resource "azurerm_linux_virtual_machine" "m-langer" {
  name                = "m-langer-vm"
  resource_group_name = azurerm_resource_group.m-langer.name
  location            = azurerm_resource_group.m-langer.location
  size                = "Standard_F2"
  admin_username      = "moritz"
  network_interface_ids = [azurerm_network_interface.m-langer.id]
  disable_password_authentication = false
  admin_password = "L0y05^nHZ6*"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  # windows iso
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  # os disk
}
tags = azurerm_network_interface.m-langer.tags
# add a public ip
}