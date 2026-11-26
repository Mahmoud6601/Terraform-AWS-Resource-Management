variable "aws_region" {
  description = "AWS region hosting the Terraform remote state backend."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Short project identifier used for naming state resources."
  type        = string
  default     = "aws-platform"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform remote state."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.state_bucket_name))
    error_message = "state_bucket_name must be a valid lowercase S3 bucket name."
  }
}

variable "lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  type        = string
  default     = "terraform-aws-platform-locks"
}

variable "create_github_oidc_provider" {
  description = "Create the GitHub Actions OIDC identity provider in this AWS account."
  type        = bool
  default     = false
}

variable "github_repository" {
  description = "Optional GitHub repository in 'owner/repo' format to trust for OIDC deployment role."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
