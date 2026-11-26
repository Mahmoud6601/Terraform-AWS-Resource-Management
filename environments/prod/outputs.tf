output "vpc_id" {
  description = "ID of the environment VPC."
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "autoscaling_group_name" {
  description = "Name of the private Auto Scaling Group."
  value       = module.compute.autoscaling_group_name
}

output "artifacts_bucket_arn" {
  description = "ARN of the encrypted S3 artifacts bucket."
  value       = module.artifacts_bucket.bucket_arn
}

output "kms_key_arn" {
  description = "ARN of the environment Customer Managed KMS key."
  value       = module.kms.key_arn
}

output "alerts_sns_topic_arn" {
  description = "ARN of the KMS-encrypted SNS alerts topic."
  value       = module.observability.sns_topic_arn
}

output "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch operational dashboard."
  value       = module.observability.dashboard_name
}
