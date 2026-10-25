output "workspace_id" {
  value       = azurerm_log_analytics_workspace.central.id
  description = "Resource ID of the central Log Analytics Workspace."
}

output "workspace_name" {
  value       = azurerm_log_analytics_workspace.central.name
  description = "Name of the central Log Analytics Workspace."
}

output "data_collection_rule_id" {
  value       = azurerm_monitor_data_collection_rule.dcr.id
  description = "Resource ID of the enterprise baseline Data Collection Rule."
}
