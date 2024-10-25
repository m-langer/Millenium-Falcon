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

 module "obiwan-vm" {
  source                        = "./modules/vm"
  nic_name                      = "vm-nic"
  location                      = azurerm_resource_group.obiwan-rg.location
  resource_group_name           = azurerm_resource_group.obiwan-rg.name
  subnet_id                   = azurerm_subnet.obiwan-subnet.id
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

module "obiwan-vnet" {
  source              = "./modules/vnet"
  vnet_name           = "obiwan-vnet"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.obiwan-rg.location
  resource_group_name = azurerm_resource_group.obiwan-rg.name
  subnet_name         = "obiwan-subnet"
  subnet_prefixes     = ["11.0.1.0/24"]
}
  