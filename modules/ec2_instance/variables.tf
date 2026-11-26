variable "name_prefix" {
  description = "Prefix used for Launch Template, Auto Scaling Group, and IAM Role names."
  type        = string
}

variable "environment" {
  description = "Deployment environment identifier (dev, staging, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "subnet_ids" {
  description = "Private subnet IDs for Auto Scaling Group placement."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "Provide at least 2 private subnets across distinct AZs."
  }
}

variable "security_group_ids" {
  description = "Security group IDs attached to instances."
  type        = list(string)
}

variable "target_group_arns" {
  description = "ALB target group ARNs registered with the Auto Scaling Group."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "Approved EC2 instance type for the compute tier."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium", "t3.large", "t3a.micro", "t3a.small", "t3a.medium"], var.instance_type)
    error_message = "instance_type must be from the approved t3/t3a allowlist."
  }
}

variable "ami_id" {
  description = "Optional AMI ID override. If null, resolves latest Amazon Linux 2023 AMI via SSM Parameter Store."
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group."
  type        = number
  default     = 1

  validation {
    condition     = var.min_size >= 1
    error_message = "min_size must be at least 1."
  }
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group."
  type        = number
  default     = 2

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group."
  type        = number
  default     = 1

  validation {
    condition     = var.desired_capacity >= 1
    error_message = "desired_capacity must be at least 1."
  }
}

variable "root_volume_size_gb" {
  description = "Encrypted gp3 root volume size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size_gb >= 8 && var.root_volume_size_gb <= 200
    error_message = "root_volume_size_gb must be between 8 and 200 GiB."
  }
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN encrypting root EBS volumes."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
