variable "name_prefix" {
  description = "Prefix used for the KMS key alias and Name tag."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9/_-]+$", var.name_prefix))
    error_message = "name_prefix must only contain alphanumeric characters, '/', '_', or '-'."
  }
}

variable "description" {
  description = "Human-readable description of the KMS key."
  type        = string
  default     = "Customer-managed KMS key for AWS platform encryption"
}

variable "deletion_window_in_days" {
  description = "Waiting period before scheduled KMS key deletion (7 to 30 days)."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

variable "tags" {
  description = "Additional tags applied to the KMS key."
  type        = map(string)
  default     = {}
}
