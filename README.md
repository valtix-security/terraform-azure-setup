# terraform-azure-valtix-iam
Create Azure AD App that is used by the Valtix Controller to manage your Azure Subscription(s). You can clone and use this as a module from your other terraform scripts.

# Requirements
1. Enable terraform to access your Azure account. Check here for the options https://registry.terraform.io/providers/hashicorp/azuread/latest/docs and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
1. Login to the Valtix Dashboard and generate an API Key using the instructions provided here: https://registry.terraform.io/providers/valtix-security/valtix/latest/docs

## Argument Reference

* `prefix` - (Required) App, Custom role are created with this prefix

## Outputs

* `tenant_id` - Azure AD Directory/Tenant Id
* `app_id` - AD App Registration Id
* `app_name` - AD App Registration Name
* `secret_key` - Secret key for the above app (Sensitive, use `terraform output -json | jq -r .secret_key.value` to see this value)
* `subscription_id` - Azure Subscription Id
* `iam_role` - Custom IAM Role name assigned to the application created

## Using as a module

To use this repo as a terraform module, remove provider.tf file or comment out the content in that file. From a top level module, call this repo as a module

### Top level module (In directory at the same level as this repo)

```
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.6.0"
      # using older version as we saw some issues creating the application with 2.x msgraph api, it was probably temporary
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}

provider "valtix" {
  api_key_file = file(var.valtix_api_key_file)
}

module "csp_setup" {
  source = "../terraform-azure-setup"
  prefix = "valtix"
}
```