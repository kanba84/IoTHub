provider "azurerm" {
    version = "=2.0.0"
    features {}
}
#########################
/// variables
#########################
variable "RG_NAME" {}
variable "LOCATION" {}
variable "IOTHUB_NAME" {}
variable "DPS_NAME" {}

#########################
/// resources
#########################
resource "azurerm_resource_group" "example" {
  name     = "${var.RG_NAME}"
  location = "${var.LOCATION}"
}

resource "azurerm_iothub" "example" {
  name                = "${var.IOTHUB_NAME}"
  resource_group_name = "${var.RG_NAME}"
  location            = "${var.LOCATION}"

  sku {
    name     = "F1"
    capacity = "1"
  }
}

resource "azurerm_iothub_dps" "example" {
  name                = "${var.DPS_NAME}"
  resource_group_name = "${var.RG_NAME}"
  location            = "${var.LOCATION}"

  sku {
    name     = "S1"
    capacity = "1"
  }

  linked_hub {
      connection_string = "HostName=${var.IOTHUB_NAME}.azure-devices.net;SharedAccessKeyName=iothubowner;SharedAccessKey=${azurerm_iothub.example.shared_access_policy.0.primary_key}"
      location = "${var.LOCATION}"
  }
}

resource "azurerm_iothub_dps_certificate" "example" {
  name = "rootca-test"
  resource_group_name = "${var.RG_NAME}"
  iot_dps_name        = "${var.DPS_NAME}"

  certificate_content = "${filebase64("azure-iot-test-only.root.ca.cert.pem")}"

}