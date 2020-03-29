#########################
/// variables
#########################
variable "resource_group" {}
variable "location" {default = "japaneast"}
variable "size" {default = "Standard_B2S"}
variable "machine_name" {default = "test-machine"}
variable "subnet" {}

#########################
/// rescources
#########################
resource "azurerm_linux_virtual_machine" "example" {
  name                = var.machine_name
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.size
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  disable_password_authentication = false
  admin_username      = "adminuser"
  admin_password      = "Pa$$w0rd1234"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = "${data.template_file.my_init_script.rendered}"
}

resource "azurerm_network_interface" "example" {
  name                = "${var.machine_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_public_ip" "example" {
  name                = "${var.machine_name}-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  allocation_method   = "Dynamic"
}

#########################
/// custom_script
#########################
data "template_file" "my_init_script" {
  template = "${filebase64("./setupVM.sh")}"
}