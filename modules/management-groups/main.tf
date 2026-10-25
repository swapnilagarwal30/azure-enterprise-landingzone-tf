terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

# Tenant Root Management Group
resource "azurerm_management_group" "root" {
  name         = "${var.root_id}-root"
  display_name = var.root_name
}

# Platform Management Group (Platform Infrastructure)
resource "azurerm_management_group" "platform" {
  name                       = "${var.root_id}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "management" {
  name                       = "${var.root_id}-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = "${var.root_id}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "identity" {
  name                       = "${var.root_id}-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

# Landing Zones Workloads Group
resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.root_id}-landingzones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "corp" {
  name                       = "${var.root_id}-corp"
  display_name               = "Corp (Internal)"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  name                       = "${var.root_id}-online"
  display_name               = "Online (Public/DMZ)"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

# Sandbox & Decommissioned
resource "azurerm_management_group" "sandbox" {
  name                       = "${var.root_id}-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "${var.root_id}-decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.root.id
}
