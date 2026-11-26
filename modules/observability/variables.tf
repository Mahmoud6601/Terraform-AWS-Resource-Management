variable "name_prefix" {
  description = "Prefix used for SNS topic, CloudWatch Log Group, alarms, and dashboard."
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metric dimensions."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ALB Target Group ARN suffix for unhealthy host alarms."
  type        = string
}

variable "autoscaling_group_name" {
  description = "Auto Scaling Group name for CPU utilization alarms."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN encrypting SNS topic and CloudWatch Log Group."
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Log Group retention in days."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
