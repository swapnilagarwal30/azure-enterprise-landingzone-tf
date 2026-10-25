output "firewall_id" {
  value       = azurerm_firewall.hub.id
  description = "Resource ID of Azure Firewall."
}

output "firewall_private_ip" {
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  description = "Private IP address of the Azure Firewall (used for UDR Next Hop)."
}

output "firewall_public_ip" {
  value       = azurerm_public_ip.firewall.ip_address
  description = "Public IP address of the Azure Firewall."
}

output "firewall_policy_id" {
  value       = azurerm_firewall_policy.policy.id
  description = "Resource ID of the Azure Firewall Policy."
}
