variable "azure_subscription_id" {
  type    = string
  default = ""
}

variable "resource_group_name" {
  description = "The name of the resource group to create the VM"
  type        = string
  default     = "vms"
}

variable "resource_group_location" {
  description = "The location in which the resources will be created."
  type        = string
  default     = "eastus2"
}

variable "number_of_instances" {
  description = "Specify the number of vm instances."
  type        = number
  default     = 5
}
