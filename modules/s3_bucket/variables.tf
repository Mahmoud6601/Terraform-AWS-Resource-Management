variable "bucket_name" {
  description = "Globally unique lowercase S3 bucket name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3-63 characters, lowercase alphanumeric, dots, or hyphens."
  }
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for SSE-KMS encryption (falls back to AES256 if null)."
  type        = string
  default     = null
}

variable "versioning_enabled" {
  description = "Enable S3 object versioning."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow destroying non-empty bucket (keep false in production)."
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "Days before noncurrent object versions expire."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days must be at least 1."
  }
}

variable "logging_target_bucket" {
  description = "Optional S3 bucket ID receiving server access logs."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for S3 server access logs."
  type        = string
  default     = "access-logs/"
}

variable "additional_bucket_policy_json" {
  description = "Optional additional IAM policy document JSON merged with the mandatory TLS-only policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
