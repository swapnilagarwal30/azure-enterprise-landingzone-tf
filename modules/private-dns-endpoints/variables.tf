variable "resource_group_name" {
  type        = string
  description = "Name of resource group."
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of Hub VNet."
}

variable "spoke_vnet_id" {
  type        = string
  description = "Resource ID of Spoke VNet."
}

variable "tags" {
  type        = map(string)
  description = "Tags map."
  default     = {}
}
