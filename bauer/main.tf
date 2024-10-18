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

resource "azurerm_network_interface" "nic-bauer" {
  name                = "nic-bauer"
  location            = azurerm_resource_group.rg_bauer.location
  resource_group_name = azurerm_resource_group.rg_bauer.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn-bauer.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-bauer-2" {
  name                = "vm-bauer-2"
  resource_group_name = azurerm_resource_group.rg_bauer.name
  location            = azurerm_resource_group.rg_bauer.location
  size                = "Standard_F2"
  disable_password_authentication = false
  admin_username      = "bauer"
  admin_password = "BauerBauer1234"
  network_interface_ids = [azurerm_network_interface.nic-bauer.id,  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}