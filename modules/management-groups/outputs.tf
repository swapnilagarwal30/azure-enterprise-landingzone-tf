output "root_id" {
  value       = azurerm_management_group.root.id
  description = "Resource ID of the Root Management Group."
}

output "platform_id" {
  value       = azurerm_management_group.platform.id
  description = "Resource ID of the Platform Management Group."
}

output "landing_zones_id" {
  value       = azurerm_management_group.landing_zones.id
  description = "Resource ID of the Landing Zones Management Group."
}

output "corp_id" {
  value       = azurerm_management_group.corp.id
  description = "Resource ID of the Corp (Internal) Management Group."
}

output "online_id" {
  value       = azurerm_management_group.online.id
  description = "Resource ID of the Online (DMZ) Management Group."
}
