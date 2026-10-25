output "vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "Resource ID of the Hub VNet."
}

output "vnet_name" {
  value       = azurerm_virtual_network.hub.name
  description = "Name of the Hub VNet."
}

output "vnet_address_space" {
  value       = azurerm_virtual_network.hub.address_space
  description = "Address space of Hub VNet."
}

output "resource_group_name" {
  value       = azurerm_resource_group.hub.name
  description = "Name of the Hub resource group."
}

output "firewall_subnet_id" {
  value       = azurerm_subnet.firewall.id
  description = "Resource ID of AzureFirewallSubnet."
}

output "firewall_mgmt_subnet_id" {
  value       = azurerm_subnet.firewall_mgmt.id
  description = "Resource ID of AzureFirewallManagementSubnet."
}

output "gateway_subnet_id" {
  value       = azurerm_subnet.gateway.id
  description = "Resource ID of GatewaySubnet."
}
