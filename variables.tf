variable "root_id" {
  type        = string
  description = "The prefix used for all management group IDs and enterprise resources."
  default     = "ent"

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.root_id))
    error_message = "The root_id must be between 2 and 10 lowercase alphanumeric characters."
  }
}

variable "root_name" {
  type        = string
  description = "The display name for the top-level tenant root management group."
  default     = "Enterprise Tenant Root"
}

variable "primary_location" {
  type        = string
  description = "Primary Azure region for hub networking, security services, and core landing zones."
  default     = "eastus"
}

variable "secondary_location" {
  type        = string
  description = "Secondary paired Azure region for disaster recovery and regional failover."
  default     = "westus2"
}

variable "environment" {
  type        = string
  description = "Deployment environment tier (prod, uat, dev)."
  default     = "prod"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
}

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "CIDR address space block for the central Hub Virtual Network."
  default     = ["10.0.0.0/16"]
}

variable "spoke_workload_address_space" {
  type        = list(string)
  description = "CIDR address space block for Spoke 1 (Application Workloads VNet)."
  default     = ["10.1.0.0/16"]
}

variable "spoke_shared_address_space" {
  type        = list(string)
  description = "CIDR address space block for Spoke 2 (Shared Services & CI/CD Runners VNet)."
  default     = ["10.2.0.0/16"]
}

variable "firewall_sku_tier" {
  type        = string
  description = "SKU tier for Azure Firewall. Standard or Premium."
  default     = "Premium"

  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "Firewall SKU must be Standard or Premium."
  }
}

variable "enable_bastion" {
  type        = bool
  description = "Boolean toggle to deploy Azure Bastion in the central Hub VNet."
  default     = true
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs in central Log Analytics Workspace."
  default     = 90

  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "Log retention days must be between 30 and 730 days."
  }
}

variable "tags" {
  type        = map(string)
  description = "Mandatory enterprise governance tags applied to all provisioned resources."
  default = {
    Architecture     = "Azure-Landing-Zones-CAF"
    ManagedBy        = "Terraform"
    Owner            = "Cloud-Architecture-Team"
    CostCenter       = "CC-1044-IT"
    SecurityBaseline = "CIS-Azure-Benchmark-v2"
  }
}
