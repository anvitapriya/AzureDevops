variable "module_base" {
  default = "https://github.com/anvitapriya/AzureDevops.git"
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

variable "storage_account_tier" {
  default     = "Storage"
  description = "storage account t"
}


variable "account_replication_type"
{
	default = "LRS"
	description = "default replication type"
}

variable "storage_access_tier"
{
   default = " "
   description = " "
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


variable "vnet_dns_servers" {
  default     = "10.105.0.0/21"
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

variable "network_security_group_id" {
  default     = ["10.105.6.0/24"]
  description = "anvita swcurity group id"
}

variable "nic_name" {
	default  = "anvitanic"
	description = "nic name"
}

variable "subnet_id"
{
	default 	 =  ""
	description  =  "subnet id"
}

variable "private_ip_address_allocation"
{
	default 	 =  ""
	description  =  "private_ip_address_allocation"
}

variable "private_ip_address"
{
	default 	 =  ""
	description  =  "private_ip_address"
}

variable "name"
{
	default  =  ""
}