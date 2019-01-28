provider "azurerm"
{


}

# For creating the remote state storage
terraform {
  backend "azure" {
    storage_account_name = "anvitastorage"
    container_name       = "anvitastorage"
    key                  = "basevms.terraform.tfstate"
    access_key           = "Na4UYXpTXBhmD6opJGFXtkrJ4GS/72MylcBdXL6WD2C/Qqaj0sJsYMygsv5rfqEh+s/ZLSe4FVabcjN48Ga5og=="
  }
}

# Create a resource group

resource "azurerm_resource_group" "anvitasresources" {
  name     = "${var.name}"
  location = "${var.location}"
  tags = "${var.tags}"
}

# create storage account

resource "azurerm_storage_account" "anvitasstorage" {
  name                     = "${var.storage_name}"
  location                 = "${var.location}"
  resource_group_name      = "${var.resource_group_name}"
  account_kind             = "${var.storage_account_kind}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.account_replication_type}"
  access_tier              = "${var.storage_access_tier}"
  enable_blob_encryption   = "${var.storage_enable_blob_encryption}"
}


resource "azurerm_virtual_network" "anvitasvnet" {
  name                = "${var.vnet_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.vnet_address_space}"]
  dns_servers         = ["${var.vnet_dns_servers}"]
}

resource "azurerm_subnet" "anvitassubnet" {
  name                      = "${var.name}"
  subnet_id                 = "${var.subnet_id}
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.virtual_network_name}"
  address_prefix            = "${var.subnet_address_spaces}"
  network_security_group_id = "${var.network_security_group_id}"
}

resource "azurerm_network_interface" "anvitanic" {
  name                = "${var.nic_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ip-config-${var.nic_name}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "${var.private_ip_address_allocation}"
    private_ip_address            = "${var.private_ip_address}"
  }

  network_security_group_id = "${var.vm_network_security_group_id}"
}

resource "azurerm_virtual_machine" "anvita-vm" {
  name                  = "${var.name}-vm"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    environment = "staging"
  }
}
