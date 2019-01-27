
# For creating the remote state storage
terraform {
  backend "azure" {
    storage_account_name = "produkscomnsada001"
    container_name       = "prod-uks-tfstat-blob-0001"
    key                  = "basevms.terraform.tfstate"
    access_key           = "Na4UYXpTXBhmD6opJGFXtkrJ4GS/72MylcBdXL6WD2C/Qqaj0sJsYMygsv5rfqEh+s/ZLSe4FVabcjN48Ga5og=="
  }
}

# Create a resource group

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}"
  location = "${var.location}"
  tags = "${var.tags}"
}

# create storage account

resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_name}"
  location                 = "${var.location}"
  resource_group_name      = "${var.resource_group_name}"
  account_kind             = "${var.storage_account_kind}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.account_replication_type}"
  access_tier              = "${var.storage_access_tier}"
  enable_blob_encryption   = "${var.storage_enable_blob_encryption}"
}

module "storage_container" {
  source = "./container"

  resource_group_name = "${var.resource_group_name}"
  storage_name        = "${azurerm_storage_account.main.name}"
  container_names     = ["${var.container_names}"]
}


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.vnet_address_space}"]
  dns_servers         = ["${var.vnet_dns_servers}"]
}

resource "azurerm_subnet" "snet" {
  count                     = "${length(var.address_spaces)}"
  name                      = "${var.name[count.index]}-${format(var.count_format, count.index + 1)}"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.virtual_network_name}"
  address_prefix            = "${var.address_spaces[count.index]}"
  network_security_group_id = "${var.network_security_group_id}"
}

resource "azurerm_network_interface" "main" {
  count               = "${var.count}"
  name                = "${var.nic_name}-${format(var.count_format, count.index + 1)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ip-config-${format(var.count_format, count.index + 1)}"
    subnet_id                     = "${var.vm_subnet_id}"
    private_ip_address_allocation = "${var.vm_private_ip_address_allocation}"
    private_ip_address            = "${var.vm_private_ip_address_allocation == "static" ? var.vm_private_ip_address : "" }"
    #public_ip_address_id          = "${var.vm_public_ip ? format("%s", element(azurerm_public_ip.main.*.id, count.index)) : "" }"
  }

  network_security_group_id = "${var.vm_network_security_group_id}"
}

resource "azurerm_virtual_machine" "main_vanilla" {
  count                 = "${!var.use_image ? var.count : "0"}"
  name                  = "${var.vm_name}-${format(var.count_format, count.index + 1)}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.main.*.id[count.index]}"]
  availability_set_id   = "${var.availability_set_id}"

  storage_image_reference {
    publisher = "${var.vm_storage_image_reference["publisher"]}"
    offer     = "${var.vm_storage_image_reference["offer"]}"
    sku       = "${var.vm_storage_image_reference["sku"]}"
    version   = "${var.vm_storage_image_reference["version"]}"
  }

  storage_os_disk {
    name    = "${var.vm_storage_os_disk_name}-${format(var.count_format, count.index + 1)}"
    vhd_uri = "${var.storage_blob_endpoint}${var.storage_container_os_disk_name}/${var.vm_name}-${var.vm_storage_os_disk_name}-${format(var.count_format, count.index + 1)}.vhd"

    os_type       = "${var.vm_storage_os_disk_type}"
    disk_size_gb  = "${var.vm_storage_os_disk_size}"
    caching       = "${var.vm_storage_os_disk["caching"]}"
    create_option = "${var.vm_storage_os_disk["create_option"]}"
  }

  os_profile {
    computer_name  = "${var.vm_name}-${format(var.count_format, count.index + 1)}"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${random_id.password.*.b64[count.index]}"
    custom_data    = "${var.vm_os_profile_custom_data}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    # ssh_keys {
    #   # path = "${var.vm_ssh_key_path}"

    #   path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
    #   key_data = "${file("${var.vm_ssh_key_name}")}"
    # }
  }

  delete_os_disk_on_termination = "${var.vm_delete_os_disk_on_termination}"

  lifecycle {
    ignore_changes = ["os_profile.admin_password"]
  }

  tags {
    Name              = "${var.vm_tags["Name"]}"
    Terraform         = "${var.vm_tags["Terraform"]}"
    Environment       = "${var.vm_tags["Environment"]}"
    Location          = "${var.vm_tags["Location"]}"
    Service           = "${var.vm_tags["Service"]}"
    Role              = "${var.vm_tags["Role"]}"
    Business_Unit     = "${var.vm_tags["Business_Unit"]}"
    EA_Application_ID = "${var.vm_tags["EA_Application_ID"]}"
    JIRA              = "${var.vm_tags["JIRA"]}"
    ExpiryDate        = "${var.vm_tags["ExpiryDate"]}"
    BC_Priority       = "${var.vm_tags["BC_Priority"]}"
  }
}
