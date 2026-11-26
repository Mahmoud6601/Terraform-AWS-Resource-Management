variable "name_prefix" {
  description = "Short prefix for ALB and target group names (max 24 chars)."
  type        = string

  validation {
    condition     = length(var.name_prefix) <= 24 && can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "name_prefix must be <= 24 characters and contain only lowercase letters, digits, and hyphens."
  }
}

variable "vpc_id" {
  description = "VPC ID hosting the ALB target group."
  type        = string
}

variable "subnet_ids" {
  description = "List of at least two public subnet IDs in distinct AZs."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "ALB requires at least 2 subnets across distinct Availability Zones."
  }
}

variable "security_group_ids" {
  description = "Security group IDs attached to the ALB."
  type        = list(string)
}

variable "internal" {
  description = "Whether the load balancer is internal-only."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Protect the ALB against accidental deletion (set true in production)."
  type        = bool
  default     = false
}

variable "target_port" {
  description = "Backend port on target instances."
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "HTTP path probed by the ALB target group health check."
  type        = string
  default     = "/healthz"
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN enabling HTTPS:443 (TLS 1.3) and HTTP->HTTPS 301 redirect."
  type        = string
  default     = null
}

variable "access_logs_bucket" {
  description = "Optional S3 bucket ID for ALB access logs."
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "S3 key prefix for ALB access logs."
  type        = string
  default     = "alb-logs"
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
