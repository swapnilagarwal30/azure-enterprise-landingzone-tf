variable "resource_group_name" {
  type        = string
  description = "Name of resource group hosting centralized monitoring."
}

variable "location" {
  type        = string
  description = "Azure region for monitoring resources."
}

variable "environment" {
  type        = string
  description = "Deployment tier."
}

variable "log_retention_days" {
  type        = number
  description = "Log retention period in days."
  default     = 90
}

variable "tags" {
  type        = map(string)
  description = "Resource tags."
  default     = {}
}
