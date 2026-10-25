variable "resource_group_name" {
  type        = string
  description = "Resource group name for hub network."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "environment" {
  type        = string
  description = "Environment tier."
}

variable "address_space" {
  type        = list(string)
  description = "Address space for Hub VNet."
  default     = ["10.0.0.0/16"]
}

variable "enable_bastion" {
  type        = bool
  description = "Whether to provision Azure Bastion."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags map."
  default     = {}
}
