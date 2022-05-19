terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

resource "azurerm_public_ip" "vm" {
  name                = "${var.resource_group_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
}

resource "azurerm_lb" "vm" {
  name                = "${var.resource_group_name}-lb"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "${var.resource_group_name}-fic"
    public_ip_address_id = azurerm_public_ip.vm.id
  }
}

resource "azurerm_lb_backend_address_pool" "vm" {
  name            = "${var.resource_group_name}-bap"
  loadbalancer_id = azurerm_lb.vm.id
}

resource "azurerm_lb_rule" "vm" {
  loadbalancer_id                = azurerm_lb.vm.id
  name                           = "${var.resource_group_name}-lb-rule"
  resource_group_name            = var.resource_group_name
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "${var.resource_group_name}-fic"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.vm.id]
}

resource "azurerm_network_interface_backend_address_pool_association" "vm" {
  count                   = length(var.network_interface_ids)
  network_interface_id    = element(var.network_interface_ids, count.index)
  ip_configuration_name   = "${var.vm_hostname_prefix}-ip-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vm.id
}