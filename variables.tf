# Module specific Variables

# Name of the resource group
variable name {}

# Geographic location of the Resource Group
variable location {
  default = "eun"
}

# "Empty" requires fufilment , please ensure you fill in as much as possible.
# "BC_Priority" P3 , P2 , P1 (default lowest priority is P3 )
# "Location" Default is NorthEurope (eun)
# "CI_build_ID" Default is empty options should be jenkins | concourse | terraform
# Date Time Format in UTC 2018-08-01T12:00:00
# Please see : https://confluence.devops.mnscorp.net/display/PT/Resource+Tagging 
variable "tags" {
  type = "map"
  description = "Resource group tags"

  default = {
    Environment = "dev"
    Location    = "eun"
    Service     = "Empty"
    Role        = "Empty"
    CI_build_ID   = "Empty"
    CI_build_link = "Empty"
    Business_Unit = "Empty"
    EA_Application_ID = "Empty"
    Expiry_Date = "Empty"
    BC_Priority = "P3"
    Cost_Centre = "Empty"
    Product_Group = "Empty"
  }
}
