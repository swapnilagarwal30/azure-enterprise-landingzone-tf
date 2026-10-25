output "dns_zone_ids" {
  value       = { for k, v in azurerm_private_dns_zone.zones : k => v.id }
  description = "Map of Private DNS Zone names to their resource IDs."
}
