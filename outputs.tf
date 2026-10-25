output "tenant_root_management_group_id" {
  value       = module.management_groups.root_id
  description = "ID of the Tenant Root Management Group."
}

output "hub_virtual_network_id" {
  value       = module.hub_network.vnet_id
  description = "ID of the central Hub VNet."
}

output "azure_firewall_private_ip" {
  value       = module.firewall.firewall_private_ip
  description = "Private IP of the Azure Firewall."
}

output "log_analytics_workspace_id" {
  value       = module.monitoring.workspace_id
  description = "ID of the central Log Analytics Workspace."
}

output "spoke_workload_vnet_id" {
  value       = module.spoke_workload.vnet_id
  description = "ID of the Workload Application Spoke VNet."
}

output "spoke_shared_vnet_id" {
  value       = module.spoke_shared.vnet_id
  description = "ID of the Shared Services Spoke VNet."
}
