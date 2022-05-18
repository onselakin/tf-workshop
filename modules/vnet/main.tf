terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

resource "azurerm_virtual_network" "vm" {
  name                = "${var.virtual_network_name}"
  address_space       = [var.virtual_network_address_space]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "vm" {
  name                 = "${var.virtual_network_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vm.name
  address_prefixes     = [var.subnet_address_prefix]
}
