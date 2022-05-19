output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "network_interface_ids" {
  description = "Ids of the network interfaces for the VMs created"
  value       = azurerm_network_interface.vm.*.id
}
