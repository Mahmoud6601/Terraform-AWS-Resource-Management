mock_provider "aws" {}

run "creates_encrypted_sns_and_alarms" {
  command = plan

  variables {
    name_prefix             = "aws-plat-dev"
    alb_arn_suffix          = "app/aws-plat-dev-alb/1234567890abcdef"
    target_group_arn_suffix = "targetgroup/aws-plat-dev-tg/1234567890abcdef"
    autoscaling_group_name  = "aws-plat-dev-asg"
    kms_key_arn             = "arn:aws:kms:us-east-1:111122223333:key/1234abcd"
    log_retention_days      = 14
  }

  assert {
    condition     = aws_sns_topic.alerts.kms_master_key_id == "arn:aws:kms:us-east-1:111122223333:key/1234abcd"
    error_message = "SNS alerts topic must be KMS encrypted."
  }

  assert {
    condition     = aws_cloudwatch_log_group.app.retention_in_days == 14
    error_message = "Log group retention must match input."
  }
}
