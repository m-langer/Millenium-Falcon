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

module "obiwan-vm" {
  source                        = "./modules/vm"
  nic_name                      = "vm-nic"
  location                      = azurerm_resource_group.confusing.location
  resource_group_name           = azurerm_resource_group.confusing.name
  subnet_id                   = azurerm_subnet.confusing.id
  # when using vnet module:
  // subnet_id                     = module.obiwan-vnet.subnet_id
  vm_name                       = "vm"
  vm_size                       = "Standard_DS1_v2"
  os_disk_name                  = "example-os-disk"
  image_publisher               = "Canonical"
  image_offer                   = "UbuntuServer"
  image_sku                     = "18.04-LTS"
  image_version                 = "latest"
  computer_name                 = "hostname"
  admin_username                = "adminuser"
  admin_password                = "Password1234!"
  disable_password_authentication = false
}

  