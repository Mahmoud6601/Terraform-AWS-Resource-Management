mock_provider "aws" {}

run "plans_full_dev_environment_wiring" {
  command = plan

  variables {
    aws_region            = "us-east-1"
    project_name          = "aws-plat"
    environment           = "dev"
    vpc_cidr              = "10.10.0.0/16"
    azs                   = ["us-east-1a", "us-east-1b"]
    public_subnets        = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnets       = ["10.10.11.0/24", "10.10.12.0/24"]
    isolated_subnets      = ["10.10.21.0/24", "10.10.22.0/24"]
    enable_nat_gateway    = true
    single_nat_gateway    = true
    artifacts_bucket_name = "aws-plat-dev-artifacts-test-001"
    s3_force_destroy      = true
    instance_type         = "t3.micro"
    ami_id                = "ami-0123456789abcdef0"
    asg_min_size          = 1
    asg_max_size          = 2
    asg_desired_capacity  = 1
    log_retention_days    = 14
  }

  assert {
    condition     = output.autoscaling_group_name == "aws-plat-dev-asg"
    error_message = "ASG name output must match environment prefix."
  }

  assert {
    condition     = output.cloudwatch_dashboard_name == "aws-plat-dev-ops-dashboard"
    error_message = "CloudWatch dashboard name must match environment prefix."
  }

  assert {
    condition     = module.vpc.vpc_cidr_block == "10.10.0.0/16"
    error_message = "VPC CIDR output must match input."
  }
}
