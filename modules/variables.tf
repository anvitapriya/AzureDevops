variable "module_base" {
  default = "git@github.com:DigitalInnovation/terraform-platform-modules/"
}

### resource-group variables
variable "resource_group_name" {
  default     = "Anvitasresources"
  description = "this is to clear evaluation"
}

variable "location" {
  default     = "Central India"
  description = "Central India"
}

### storage variables

variable "storage_account_name" {
  default     = "anvitasstorage"
  description = "MStorage Account name. It will keep installables, terraform states etc"
}

variable "storage_account_kind" {
  default     = "Storage"
  description = "Account Kind Storage."
}

variable "storage_account_type" {
  default     = "Standard_LRS"
  description = "Storage to be created as Standard Local Redundant Storage."
}

variable "storage_enable_blob_encryption" {
  default     = false
  description = "Flag to enable blob encryption for common Storage account."
}

variable "container_names" {
  default     = ["anvita-bnry-blob-0001", "anvita-tfstat-blob-0001"]
  description = "List of Containers to be created for common storage. one for binaries and other for terraform remote states"
}


### virtual network variables

variable "vnet_name" {
  default     = "anvitasvnet"
  description = "anvita virtual network"
}

variable "vnet_address_space" {
  default     = "10.105.0.0/20"
  description = "Address space of anvita virtual network."
}

variable "subnet_name" {
  default     = "anvitassubnet"
  description = "Subnet of anvita virtual network."
}

variable "subnet_address_spaces" {
  default     = ["10.105.6.0/24"]
  description = "anvita subnet address spaces."
}
