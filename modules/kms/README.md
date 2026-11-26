# KMS Module

Provisions a Customer Managed KMS Key (`aws_kms_key`) with automatic annual key rotation enabled and a least-privilege key policy scoped to the current AWS account and region for CloudWatch Logs, SNS, EBS, and S3 encryption.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name_prefix` | `string` | required | Alias suffix (`alias/<name_prefix>`) and `Name` tag prefix |
| `description` | `string` | `"Customer-managed KMS key..."` | Key description |
| `deletion_window_in_days` | `number` | `30` | Deletion window (`7`–`30` days) |
| `tags` | `map(string)` | `{}` | Additional resource tags |

## Outputs

| Name | Description |
| --- | --- |
| `key_id` | KMS key ID |
| `key_arn` | KMS key ARN |
| `alias_name` | KMS alias name |
