terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "cloud-init.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/scripts/cloud-init.cfg", {
      PORT : var.remote_port
    })
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.number_of_instances
  name                  = "${var.vm_hostname}-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  availability_set_id   = azurerm_availability_set.vm.id
  network_interface_ids = [element(azurerm_network_interface.vm.*.id, count.index)]
  size                  = "Standard_DS1_v2"
  custom_data           = data.template_cloudinit_config.config.rendered

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.vm_hostname}-${count.index}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  computer_name                   = "${var.vm_hostname}-${count.index}"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }
}

resource "azurerm_availability_set" "vm" {
  name                         = "${var.vm_hostname}-avset"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_security_group" "vm" {
  name                = "${var.vm_hostname}-nsg"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm" {
  count               = var.number_of_instances
  name                = "${var.vm_hostname}-nic-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "${var.vm_hostname}-ip-${count.index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  count                     = var.number_of_instances
  network_interface_id      = azurerm_network_interface.vm[count.index].id
  network_security_group_id = azurerm_network_security_group.vm.id
}
