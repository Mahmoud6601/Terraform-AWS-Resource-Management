mock_provider "aws" {}

run "creates_multi_az_vpc_with_single_nat" {
  command = plan

  variables {
    name                    = "test-dev"
    cidr                    = "10.10.0.0/16"
    azs                     = ["us-east-1a", "us-east-1b"]
    public_subnets          = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnets         = ["10.10.11.0/24", "10.10.12.0/24"]
    isolated_subnets        = ["10.10.21.0/24", "10.10.22.0/24"]
    enable_nat_gateway      = true
    single_nat_gateway      = true
    enable_flow_logs        = true
    flow_log_retention_days = 14
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets."
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Expected 2 private subnets."
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 1
    error_message = "Expected 1 NAT Gateway when single_nat_gateway = true."
  }

  assert {
    condition     = length(aws_flow_log.this) == 1
    error_message = "Expected VPC Flow Log to be created when enable_flow_logs = true."
  }
}

run "creates_ha_nat_gateways_per_az" {
  command = plan

  variables {
    name               = "test-prod"
    cidr               = "10.30.0.0/16"
    azs                = ["us-east-1a", "us-east-1b"]
    public_subnets     = ["10.30.1.0/24", "10.30.2.0/24"]
    private_subnets    = ["10.30.11.0/24", "10.30.12.0/24"]
    enable_nat_gateway = true
    single_nat_gateway = false
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 2
    error_message = "Expected 2 NAT Gateways in HA mode."
  }
}

run "rejects_invalid_cidr" {
  command = plan

  variables {
    name            = "test-bad"
    cidr            = "999.0.0.0/16"
    azs             = ["us-east-1a", "us-east-1b"]
    public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnets = ["10.10.11.0/24", "10.10.12.0/24"]
  }

  expect_failures = [
    var.cidr
  ]
}
