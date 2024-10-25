resource "azurerm_resource_group" "confusing" {
  name     = "confusing-resources"
  location = "israelcentral"

  tags = {
      owner = "wayne.woodroffe@redbull.com"
  }
}

resource "azurerm_virtual_network" "confusing" {
  name                = "confusing-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.confusing.location
  resource_group_name = azurerm_resource_group.confusing.name
}

resource "azurerm_subnet" "confusing" {
  name                 = "confusing-subnet"
  resource_group_name  = azurerm_resource_group.confusing.name
  virtual_network_name = azurerm_virtual_network.confusing.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
}

}
resource "azurerm_network_interface" "confusing" {
  name                = "confusing-nic"
  location            = azurerm_resource_group.confusing.location
  resource_group_name = azurerm_resource_group.confusing.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.confusing.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "confusing" {
  name                = "confusing-machine"
  resource_group_name = azurerm_resource_group.confusing.name
  location            = azurerm_resource_group.confusing.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  disable_password_authentication = false
  admin_password = "ThisisLondon56"
  network_interface_ids = [
    azurerm_network_interface.confusing.id,
  ]

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