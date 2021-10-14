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

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "current" {
}
