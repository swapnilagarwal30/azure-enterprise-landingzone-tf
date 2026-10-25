variable "resource_group_name" {
  type        = string
  description = "Name of resource group."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "environment" {
  type        = string
  description = "Environment tier."
}

variable "sku_tier" {
  type        = string
  description = "Firewall SKU: Standard or Premium."
  default     = "Premium"
}

variable "firewall_subnet_id" {
  type        = string
  description = "Resource ID of the AzureFirewallSubnet."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of central Log Analytics Workspace."
}

variable "tags" {
  type        = map(string)
  description = "Tags map."
  default     = {}
}
