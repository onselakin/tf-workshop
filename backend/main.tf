terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
}

resource "random_integer" "tfstate" {
  min     = 1
  max     = 50000
}

resource "azurerm_resource_group" "terraform-state" {
  name     = var.state_resource_group_name
  location = var.state_resource_group_location
}

resource "azurerm_storage_account" "terraform-state" {
  name                     = "${var.state_storage_account_name}${random_integer.tfstate.result}"
  resource_group_name      = azurerm_resource_group.terraform-state.name
  location                 = azurerm_resource_group.terraform-state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "terraform-state" {
  name                  = var.state_storage_container_name
  storage_account_name  = azurerm_storage_account.terraform-state.name
  container_access_type = "private"
}