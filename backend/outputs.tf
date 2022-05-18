output "resource_group_name" {
  value       = var.state_resource_group_name
  description = "Storage account name"

  depends_on = [
    azurerm_storage_account.terraform-state
  ]
}

output "storage_account_name" {
  value       = azurerm_storage_account.terraform-state.name
  description = "Storage account name"

  depends_on = [
    azurerm_storage_account.terraform-state
  ]
}

output "container_name" {
  value       = var.state_storage_container_name
  description = "Storage container name"
  sensitive   = true

  depends_on = [
    azurerm_storage_container.terraform-state
  ]
}

output "access_key" {
  value       = azurerm_storage_account.terraform-state.primary_access_key
  description = "Storage access key"
  sensitive   = true

  depends_on = [
    azurerm_storage_account.terraform-state
  ]
}
