terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
  }
}

resource "azurerm_resource_group" "monitoring" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "central" {
  name                = "log-${var.environment}-${var.location}-central"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Data Collection Rule for Azure Monitor Agent (AMA) - FinOps tuned to filter noisy logs
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "dcr-${var.environment}-enterprise-baseline"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.central.id
      name                  = "central-law-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Perf"]
    destinations = ["central-law-destination"]
  }

  data_sources {
    syslog {
      facility_names = ["auth", "authpriv", "cron", "daemon", "mark", "kern"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "filtered-syslog-datasource"
      streams        = ["Microsoft-Syslog"]
    }

    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\Memory\\% Committed Bytes In Use",
        "\\LogicalDisk(_Total)\\% Free Space"
      ]
      name = "baseline-perf-counters"
    }
  }
}
