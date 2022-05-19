terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "vms-state"
    storage_account_name = "<STORAGE_ACCOUNT_NAME>"
    container_name       = "tfstatec"
    key                  = "vms-playground/terraform.tfstate"
    access_key           = "<ACCESS_KEY_FOR_STORAGE>"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
}


resource "azurerm_resource_group" "vm" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

locals {
  vm_hostname = "vm-linux"
  vnet_name   = "vm-linux-vnet"
}

module "vnet" {
  source = "./modules/vnet"

  resource_group_name           = azurerm_resource_group.vm.name
  resource_group_location       = azurerm_resource_group.vm.location
  virtual_network_name          = "${local.vm_hostname}-vnet"
  virtual_network_address_space = "10.0.0.0/16"
  subnet_address_prefix         = "10.0.1.0/24"
}

module "web-server" {
  source = "./modules/web-server"

  resource_group_name     = azurerm_resource_group.vm.name
  resource_group_location = azurerm_resource_group.vm.location
  vm_hostname             = local.vm_hostname
  number_of_instances     = var.number_of_instances
  virtual_network_name    = local.vnet_name
  subnet_id               = module.vnet.subnet_id
  remote_port             = "8080"
}

module "load-balancer" {
  source = "./modules/load-balancer"

  resource_group_name     = azurerm_resource_group.vm.name
  resource_group_location = azurerm_resource_group.vm.location
  network_interface_ids   = module.web-server.network_interface_ids
  vm_hostname_prefix      = local.vm_hostname
}
