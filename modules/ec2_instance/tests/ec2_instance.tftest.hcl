mock_provider "aws" {}

run "enforces_imdsv2_and_encrypted_ebs" {
  command = plan

  variables {
    name_prefix        = "aws-plat-dev"
    environment        = "dev"
    subnet_ids         = ["subnet-11111111", "subnet-22222222"]
    security_group_ids = ["sg-11111111"]
    instance_type      = "t3.micro"
    ami_id             = "ami-0123456789abcdef0"
    min_size           = 1
    max_size           = 2
    desired_capacity   = 1
    kms_key_arn        = "arn:aws:kms:us-east-1:111122223333:key/1234abcd"
  }

  assert {
    condition     = aws_launch_template.this.metadata_options[0].http_tokens == "required"
    error_message = "Launch template must enforce IMDSv2 (http_tokens = required)."
  }

  assert {
    condition     = aws_launch_template.this.block_device_mappings[0].ebs[0].encrypted == "true"
    error_message = "Root EBS volume must be encrypted."
  }
}

run "rejects_unapproved_instance_type" {
  command = plan

  variables {
    name_prefix        = "aws-plat-dev"
    environment        = "dev"
    subnet_ids         = ["subnet-11111111", "subnet-22222222"]
    security_group_ids = ["sg-11111111"]
    instance_type      = "p4d.24xlarge"
    ami_id             = "ami-0123456789abcdef0"
  }

  expect_failures = [
    var.instance_type
  ]
}
