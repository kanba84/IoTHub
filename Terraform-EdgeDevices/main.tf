provider "azurerm" {
    version = "=2.0.0"
    features {}
}
#########################
/// variables
#########################
variable "RG_NAME" {}
variable "LOCATION" {}
variable "VNET_NAME" {}

resource "azurerm_resource_group" "example" {
  name     = "${var.RG_NAME}"
  location = "${var.LOCATION}"
}
resource "azurerm_virtual_network" "example" {
  name                = "${var.VNET_NAME}"
  resource_group_name = "${var.RG_NAME}"
  location            = "${var.LOCATION}"
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "sub1" {
  name                 = "subnet1"
  resource_group_name  = "${var.RG_NAME}"
  virtual_network_name = "${var.VNET_NAME}"
  address_prefix       = "10.0.1.0/24"
}
resource "azurerm_subnet" "sub2" {
  name                 = "subnet2"
  resource_group_name  = "${var.RG_NAME}"
  virtual_network_name = "${var.VNET_NAME}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_security_group" "example" {
  name = "EdgeDevices-NSG"
  resource_group_name = "${var.RG_NAME}"
  location            = "${var.LOCATION}"

  security_rule {
      name                       = "AllowSSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 22
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }
  security_rule {
      name                       = "AllowHTTP"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 80
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }
  security_rule {
      name                       = "AllowHTTPS"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 443
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }
  security_rule {
      name                       = "AllowIoTEdge01"
      priority                   = 400
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 5671
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }
  security_rule {
      name                       = "AllowIoTEdge02"
      priority                   = 500
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 8883
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "example01" {
  subnet_id                 = "${azurerm_subnet.sub1.id}"
  network_security_group_id = "${azurerm_network_security_group.example.id}"
}

resource "azurerm_subnet_network_security_group_association" "example02" {
  subnet_id                 = "${azurerm_subnet.sub2.id}"
  network_security_group_id = "${azurerm_network_security_group.example.id}"
}

#########################
/// Virtual Machines
#########################
module "vm_1" {
  source        = "./module"
  resource_group = "${var.RG_NAME}"
  machine_name   = "Ubuntu-01"  
  subnet         = azurerm_subnet.sub1
}

module "vm_2" {
  source        = "./module"
  resource_group = "${var.RG_NAME}"
  machine_name   = "Ubuntu-02"
  subnet         = azurerm_subnet.sub1
}

module "vm_3" {
  source        = "./module"
  resource_group = "${var.RG_NAME}"
  machine_name   = "Ubuntu-03"
  subnet         = azurerm_subnet.sub2
}

module "vm_4" {
  source        = "./module"
  resource_group = "${var.RG_NAME}"
  machine_name   = "Ubuntu-04"
  subnet         = azurerm_subnet.sub2
}