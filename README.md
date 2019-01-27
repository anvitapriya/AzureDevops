Module for Azure `resource group`
====================

A Terraform module to provide a `resource group` in Azure.

Module Input Variables
----------------------

- `name` - resource group name
- `location` - azure location environment (default set to `north europe`)
- `tags` - azure resource group tags as `type map`
  - Please see : <https://confluence.devops.mnscorp.net/display/PT/Resource+Tagging>

Usage
-----

```hcl
module "resource_group" {
  source = "git::ssh://git@github.com/DigitalInnovation/terraform-platform-modules.git//azure/common/resource-group?ref=1.0.5"

  name = "${var.resource_group}"
  location = "${var.location}"
  tags = "${var.tags}"
}

```

Outputs
=======

- `id` - resource group id
- `name` - resource group name