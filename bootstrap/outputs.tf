output "state_bucket_name" {
  description = "Name of the S3 bucket storing Terraform remote state."
  value       = aws_s3_bucket.tfstate.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket storing Terraform remote state."
  value       = aws_s3_bucket.tfstate.arn
}

output "lock_table_name" {
  description = "Name of the DynamoDB table used for state locking."
  value       = aws_dynamodb_table.tfstate_lock.name
}

output "kms_key_arn" {
  description = "ARN of the KMS key encrypting Terraform state."
  value       = aws_kms_key.tfstate.arn
}

output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions OIDC IAM role (null if github_repository is empty)."
  value       = var.github_repository != "" ? aws_iam_role.github_actions_deploy[0].arn : null
}
