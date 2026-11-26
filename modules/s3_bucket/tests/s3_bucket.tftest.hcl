mock_provider "aws" {}

run "enforces_s3_hardening" {
  command = plan

  variables {
    bucket_name        = "aws-plat-dev-artifacts-12345"
    kms_key_arn        = "arn:aws:kms:us-east-1:111122223333:key/1234abcd"
    versioning_enabled = true
    force_destroy      = false
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls == true && aws_s3_bucket_public_access_block.this.restrict_public_buckets == true
    error_message = "Public access block must be enabled."
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.this.rule[0].object_ownership == "BucketOwnerEnforced"
    error_message = "Object ownership must be BucketOwnerEnforced."
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "Bucket versioning must be Enabled."
  }
}

run "rejects_uppercase_bucket_name" {
  command = plan

  variables {
    bucket_name = "INVALID_UPPERCASE_BUCKET"
  }

  expect_failures = [
    var.bucket_name
  ]
}
