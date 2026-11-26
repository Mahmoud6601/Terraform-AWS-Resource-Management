variable "aws_region" {
  description = "AWS region for this environment."
  type        = string
}

variable "project_name" {
  description = "Short project prefix (lowercase alphanumeric and hyphens)."
  type        = string
  default     = "aws-plat"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR block."
  type        = string
}

variable "azs" {
  description = "Availability Zones for subnet placement."
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

variable "private_subnets" {
  description = "Private application subnet CIDRs."
  type        = list(string)
}

variable "isolated_subnets" {
  description = "Optional isolated data subnet CIDRs."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateways for private subnet egress."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway (true for dev, false for HA prod)."
  type        = bool
  default     = false
}

variable "artifacts_bucket_name" {
  description = "Globally unique lowercase S3 bucket name for environment artifacts."
  type        = string
}

variable "s3_force_destroy" {
  description = "Allow destroying non-empty S3 bucket (keep false in prod)."
  type        = bool
  default     = false
}

variable "alb_deletion_protection" {
  description = "Protect ALB from accidental deletion (true in prod)."
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN for HTTPS:443 TLS 1.3 listener."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Approved EC2 instance type."
  type        = string
}

variable "ami_id" {
  description = "Optional AMI override (null resolves latest AL2023 via SSM)."
  type        = string
  default     = null
}

variable "asg_min_size" {
  description = "Auto Scaling Group minimum capacity."
  type        = number
}

variable "asg_max_size" {
  description = "Auto Scaling Group maximum capacity."
  type        = number
}

variable "asg_desired_capacity" {
  description = "Auto Scaling Group desired capacity."
  type        = number
}

variable "root_volume_size_gb" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
}

variable "kms_deletion_window_in_days" {
  description = "KMS key deletion waiting period (7-30 days)."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional environment tags."
  type        = map(string)
  default     = {}
}
