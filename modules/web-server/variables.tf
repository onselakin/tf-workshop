variable "resource_group_name" {
  description = "The name of the resource group to create the VM"
  type        = string
}

variable "resource_group_location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
}

variable "vm_hostname" {
  description = "Host name for the virtual machine(s)"
  type=string
}

variable "number_of_instances" {
  description = "Specify the number of vm instances."
  type        = number
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_id" {
  description = "The id of the subnet to connect the VMs to"
  type        = string
}

variable "remote_port" {
  description = "Remote tcp port to be used for access to the vms created via the nsg applied to the nics."
  type        = string
  default     = "8080"
}

