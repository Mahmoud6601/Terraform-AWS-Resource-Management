variable "name" {
  description = "Name prefix applied to the VPC and all networking resources."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "cidr" {
  description = "IPv4 CIDR block for the VPC (for example, 10.10.0.0/16)."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "cidr must be a valid IPv4 CIDR block."
  }
}

variable "azs" {
  description = "Ordered list of Availability Zones for subnet placement."
  type        = list(string)

  validation {
    condition     = length(var.azs) >= 2
    error_message = "Provide at least 2 availability zones for high availability."
  }
}

variable "public_subnets" {
  description = "List of IPv4 CIDR blocks for public subnets (one per AZ)."
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) >= 2 && alltrue([for c in var.public_subnets : can(cidrhost(c, 0))])
    error_message = "public_subnets must contain at least 2 valid IPv4 CIDR blocks."
  }
}

variable "private_subnets" {
  description = "List of IPv4 CIDR blocks for private application subnets (one per AZ)."
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) >= 2 && alltrue([for c in var.private_subnets : can(cidrhost(c, 0))])
    error_message = "private_subnets must contain at least 2 valid IPv4 CIDR blocks."
  }
}

variable "isolated_subnets" {
  description = "Optional list of IPv4 CIDR blocks for isolated data subnets with no internet route."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.isolated_subnets : can(cidrhost(c, 0))])
    error_message = "All isolated_subnets entries must be valid IPv4 CIDR blocks."
  }
}

variable "enable_nat_gateway" {
  description = "Provision NAT Gateways so private subnets have outbound internet access."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single shared NAT Gateway (cost-optimized for dev) instead of one per AZ."
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs to an encrypted CloudWatch Log Group."
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "CloudWatch Log retention in days for VPC Flow Logs."
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.flow_log_retention_days)
    error_message = "flow_log_retention_days must be a valid CloudWatch Logs retention period."
  }
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN encrypting the VPC Flow Logs CloudWatch Log Group."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
