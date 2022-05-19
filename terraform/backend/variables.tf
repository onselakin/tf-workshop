variable "azure_subscription_id" {
  type    = string
  default = ""
}

variable "state_resource_group_name" {
  type        = string
  description = "Resource group to create the state resources in"
  default     = "vms-state"
}

variable "state_resource_group_location" {
  type        = string
  description = "Resource group to create the state resources in"
  default     = "eastus2"
}

variable "state_storage_account_name" {
  type        = string
  description = "Storage account to store the state"
  default     = "tfstatesa"
}

variable "state_storage_container_name" {
  type        = string
  description = "Storage container to store the state"
  default     = "tfstatec"
}
