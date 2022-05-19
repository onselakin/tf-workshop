variable "resource_group_name" {
  description = "The name of the resource group to create the VM"
  type        = string
}

variable "resource_group_location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
}

variable "network_interface_ids" {
  description = "Ids of the network interfaces for the VMs created"
  type        = list(string)
}

variable "vm_hostname_prefix" {
  description = "Host name prefix for the virtual machine(s). Used to find the ipconfiguration for the hosts"
  type=string
}