output "vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "Resource ID of the Spoke VNet."
}

output "vnet_name" {
  value       = azurerm_virtual_network.spoke.name
  description = "Name of the Spoke VNet."
}

output "app_subnet_id" {
  value       = azurerm_subnet.app.id
  description = "Resource ID of the App subnet."
}

output "db_subnet_id" {
  value       = azurerm_subnet.db.id
  description = "Resource ID of the DB subnet."
}

output "private_endpoints_subnet_id" {
  value       = azurerm_subnet.private_endpoints.id
  description = "Resource ID of the Private Endpoints subnet."
}

output "route_table_id" {
  value       = azurerm_route_table.spoke.id
  description = "Resource ID of the Spoke Route Table."
}
