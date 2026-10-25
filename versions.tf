terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0, < 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.45.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.12.0"
    }
  }

  backend "azurerm" {
    # Populated dynamically via pipeline or backend.tfvars
    # resource_group_name  = "rg-terraform-state"
    # storage_account_name = "sttfstateenterprise"
    # container_name       = "tfstate"
    # key                  = "landingzones/enterprise.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = true
      skip_shutdown_and_force_delete = false
    }
  }
}

provider "azuread" {}

provider "azapi" {}
