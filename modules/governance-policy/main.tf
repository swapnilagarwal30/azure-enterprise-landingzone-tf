terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

# 1. Require Environment Tag Policy Assignment at Root Management Group
resource "azurerm_management_group_policy_assignment" "require_env_tag" {
  name                 = "audit-required-env-tag"
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3bacb2d542" # Require a tag on resources
  display_name         = "Enforce Mandatory Environment Tag"
  description          = "Audits or denies resource creation without an Environment tag for enterprise governance."

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}

# 2. Restrict Allowed Locations Policy Assignment
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "deny-unapproved-regions"
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c" # Allowed locations
  display_name         = "Restrict Approved Azure Regions"
  description          = "Enforces deployment strictly within compliant enterprise Azure regions."

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}
