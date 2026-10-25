terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

resource "azurerm_public_ip" "firewall" {
  name                = "pip-afw-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

# Azure Firewall Policy with IDPS & Threat Intelligence
resource "azurerm_firewall_policy" "policy" {
  name                     = "afwp-${var.environment}-${var.location}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku_tier
  threat_intelligence_mode = "Alert"
  tags                     = var.tags

  intrusion_detection {
    mode = var.sku_tier == "Premium" ? "Deny" : "Off"
  }

  dns {
    proxy_enabled = true
  }
}

# Centralized Network & App Rule Collection
resource "azurerm_firewall_policy_rule_collection_group" "baseline" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 200

  network_rule_collection {
    name     = "AllowInterSpokeTraffic"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "SpokeToSpokeAppTraffic"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["10.0.0.0/8"]
      destination_ports     = ["80", "443", "8080", "8443", "5432", "1433"]
    }
  }

  network_rule_collection {
    name     = "AllowNTPandDNS"
    priority = 200
    action   = "Allow"
    rule {
      name                  = "OutboundNTP"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
  }

  application_rule_collection {
    name     = "ApprovedInternetEgress"
    priority = 300
    action   = "Allow"
    rule {
      name = "AllowAzureAndOSUpdates"
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses = ["10.0.0.0/8"]
      destination_fqdns = [
        "*.microsoft.com",
        "*.azure.com",
        "*.windowsupdate.com",
        "github.com",
        "*.github.com",
        "archive.ubuntu.com"
      ]
    }
  }
}

# Azure Firewall Deployment
resource "azurerm_firewall" "hub" {
  name                = "afw-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.policy.id
  zones               = ["1", "2", "3"]
  tags                = var.tags

  ip_configuration {
    name                 = "firewall-ipconfig"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# Send Firewall Diagnostics to central Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "firewall_diag" {
  name                       = "diag-afw-${var.environment}"
  target_resource_id         = azurerm_firewall.hub.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  enabled_log {
    category = "AzureFirewallDnsProxy"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
