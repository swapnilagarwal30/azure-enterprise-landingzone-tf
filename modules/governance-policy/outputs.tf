output "env_tag_policy_assignment_id" {
  value       = azurerm_management_group_policy_assignment.require_env_tag.id
  description = "Resource ID of the Environment Tag Policy Assignment."
}

output "allowed_locations_policy_assignment_id" {
  value       = azurerm_management_group_policy_assignment.allowed_locations.id
  description = "Resource ID of the Allowed Locations Policy Assignment."
}
