variable "resource_group_name" {
  description = "The name of the resource group to create the VM"
  type        = string
}

variable "resource_group_location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space that is used the virtual network"
  type        = string
}

variable "subnet_address_prefix" {
  description = " The address prefixes to use for the subnet"
  type        = string
}
