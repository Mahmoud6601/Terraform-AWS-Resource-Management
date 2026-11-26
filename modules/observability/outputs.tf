output "sns_topic_arn" {
  description = "ARN of the KMS-encrypted SNS alert topic."
  value       = aws_sns_topic.alerts.arn
}

output "log_group_name" {
  description = "Name of the encrypted CloudWatch Log Group."
  value       = aws_cloudwatch_log_group.app.name
}

output "dashboard_name" {
  description = "Name of the CloudWatch operational dashboard."
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}
