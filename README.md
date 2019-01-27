Module for Azure `resource group`
====================

A Terraform module to provide a `resource group` in Azure.

Module Input Variables
----------------------

- `name` - resource group name
- `location` - azure location environment (default set to `north europe`)
- `tags` - azure resource group tags as `type map`
 
Usage
-----

```hcl
module "resource_group" {

  name = "${var.resource_group}"
  location = "${var.location}"
  tags = "${var.tags}"
}

```

Outputs
=======

- `id` - resource group id
- `name` - resource group name
