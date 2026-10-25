variable "management_group_id" {
  type        = string
  description = "Target management group ID for policy assignments."
}

variable "allowed_locations" {
  type        = list(string)
  description = "List of approved Azure regions."
  default     = ["eastus", "westus2", "centralus"]
}
