variable "resource_group_name" {
  type        = string
  description = "Name of the spoke resource group."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "environment" {
  type        = string
  description = "Environment tier."
}

variable "spoke_name" {
  type        = string
  description = "Identifier for the spoke (e.g. app, shared)."
}

variable "address_space" {
  type        = list(string)
  description = "CIDR address space block for spoke VNet."
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of Hub VNet."
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of Hub VNet."
}

variable "hub_resource_group_name" {
  type        = string
  description = "Resource group name of Hub VNet."
}

variable "firewall_private_ip" {
  type        = string
  description = "Private IP address of Azure Firewall."
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
