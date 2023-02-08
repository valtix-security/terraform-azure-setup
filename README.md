# terraform-azure-valtix-iam
Create Azure AD App that is used by the Valtix Controller to manage your Azure Subscription(s). You can clone and use this as a module from your other terraform scripts.

# Requirements
1. Enable terraform to access your Azure account. Check here for the options https://registry.terraform.io/providers/hashicorp/azuread/latest/docs and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
1. Set the default subscription to work on
1. Login to the Valtix Dashboard and generate an API Key using the instructions provided here: https://registry.terraform.io/providers/valtix-security/valtix/latest/docs

## Argument Reference

* `prefix` - (Required) App, Custom role are created with this prefix
* `subscription_guids_list` - List of subscriptions (Ids) to which IAM role is assigned and prepared to be onboarded onto the Valtix Controller. Default is to use the current active subscription on the current login

## Outputs

* `tenant_id` - Azure AD Directory/Tenant Id
* `app_id` - AD App Registration Id
* `app_name` - AD App Registration Name
* `secret_key` - Secret key for the above app (Sensitive, use `terraform output -json | jq -r .secret_key.value` to see this value)
* `subscription_ids` - List of Azure Subscription Ids
* `iam_role` - Custom IAM Role name assigned to the application created

## Running as root module
```
git clone https://github.com/valtix-security/terraform-azure-setup.git
cd terraform-azure-setup
mv provider provider.tf
cp values.sample values
```

Edit `values` file with the appropriate values for the variables

```
terraform init
terraform apply -var-file values
```

## Using as a module (non-root module)
*To onboard the subscription onto the Valtix Controller, uncomment the valtix sections in the following example and change the other values appropriately*

Create a tf file with the following content

```hcl
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.6.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    # valtix = {
    #   source = "valtix-security/valtix"
    # }
  }
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}

module "csp_setup" {
  source                  = "github.com/valtix-security/terraform-azure-setup"
  prefix                  = "valtix"
  subscription_guids_list = []
}

# provider "valtix" {
#   api_key_file = file("~/valtix-controller-api-key.json")
# }

# resource "valtix_cloud_account" "azure" {
#   count                 = length(module.csp_setup.subscription_ids)
#   name                  = "azure-${module.csp_setup.subscription_ids[count.index]}"
#   csp_type              = "AZURE"
#   azure_directory_id    = module.csp_setup.tenant_id
#   azure_subscription_id = module.csp_setup.subscription_ids[count.index]
#   azure_application_id  = module.csp_setup.app_id
#   azure_client_secret   = module.csp_setup.secret_key
#   inventory_monitoring {
#     regions = ["us-east1", "us-west1"]
#   }
# }

```