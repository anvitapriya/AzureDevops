# Composing a common stack in azure using tf modules for common components like startup resource group, storage etc

# Creating a resource group for associating further resources with it.

module "resource_group" {
  source   = "git::ssh://git@github.com/DigitalInnovation/terraform-platform-modules.git//azure/common/resource-group"
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

# Creating a storage group which will create a storage account and storage containers
module "storage_group" {
  source                         = "git::ssh://git@github.com/DigitalInnovation/terraform-platform-modules.git//azure/storage"
  storage_name                   = "${var.storage_account_name}"
  location                       = "${var.location}"
  resource_group_name            = "${module.resource_group.name}"
  storage_account_kind           = "${var.storage_account_kind}"
  storage_account_type           = "${var.storage_account_type}"
  storage_enable_blob_encryption = "${var.storage_enable_blob_encryption}"
  container_names                = "${var.container_names}"
}

# Creating Key vault group
module "key_vault_group" {
  source                      = "git::ssh://git@github.com/DigitalInnovation/terraform-platform-modules.git//azure/encryption"
  name                        = "${var.keyvault_name}"
  resource_group_name         = "${module.resource_group.name}"
  location                    = "${var.location}"
  tenant_id                   = "${var.tenant_id}"
  object_id                   = "${var.object_id}"
  key_permissions             = ["${var.key_permissions}"]
  secret_permissions          = ["${var.secret_permissions}"]
  enabled_for_disk_encryption = "${var.enabled_for_disk_encryption}"
  sku                         = "${var.sku_name}"
}

# Creating a virtual network which will create a virtual network and subnet
module "virtual_network_group" {
  source                = "git::ssh://git@github.com/DigitalInnovation/terraform-platform-modules.git//azure/network"
  vnet_name             = "${var.vnet_name}"
  location              = "${var.location}"
  resource_group_name   = "${module.resource_group.name}"
  vnet_address_space    = "${var.vnet_address_space}"
  subnet_name           = "${var.subnet_name}"
  subnet_address_spaces = "${var.subnet_address_spaces}"
}
