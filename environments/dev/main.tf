locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "kms" {
  source = "../../modules/kms"

  name_prefix             = local.name_prefix
  description             = "KMS key for ${local.name_prefix} S3, EBS, CloudWatch Logs, and SNS encryption"
  deletion_window_in_days = var.kms_deletion_window_in_days
  tags                    = var.tags
}

module "vpc" {
  source = "../../modules/vpc"

  name                    = local.name_prefix
  cidr                    = var.vpc_cidr
  azs                     = var.azs
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  isolated_subnets        = var.isolated_subnets
  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = var.single_nat_gateway
  enable_flow_logs        = true
  flow_log_retention_days = var.log_retention_days
  kms_key_arn             = module.kms.key_arn
  tags                    = var.tags
}

module "alb_sg" {
  source = "../../modules/security_group"

  name        = "${local.name_prefix}-alb-sg"
  description = "Ingress security group for public Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    http = {
      description = "Allow HTTP for HTTPS redirect or dev probe"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    https = {
      description = "Allow HTTPS traffic from internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  egress_rules = {
    to_vpc = {
      description = "Forward HTTP traffic to targets inside VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  tags = var.tags
}

module "app_sg" {
  source = "../../modules/security_group"

  name        = "${local.name_prefix}-app-sg"
  description = "Private compute security group allowing HTTP only from ALB SG (zero SSH)"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    from_alb = {
      description                  = "Allow HTTP strictly from ALB security group"
      from_port                    = 80
      to_port                      = 80
      protocol                     = "tcp"
      referenced_security_group_id = module.alb_sg.security_group_id
    }
  }

  egress_rules = {
    https_outbound = {
      description = "Allow outbound HTTPS for SSM Agent and OS security updates"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = var.tags
}

module "artifacts_bucket" {
  source = "../../modules/s3_bucket"

  bucket_name                        = var.artifacts_bucket_name
  kms_key_arn                        = module.kms.key_arn
  versioning_enabled                 = true
  force_destroy                      = var.s3_force_destroy
  noncurrent_version_expiration_days = var.log_retention_days
  tags                               = var.tags
}

module "alb" {
  source = "../../modules/alb"

  name_prefix                = local.name_prefix
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.public_subnet_ids
  security_group_ids         = [module.alb_sg.security_group_id]
  enable_deletion_protection = var.alb_deletion_protection
  certificate_arn            = var.acm_certificate_arn
  health_check_path          = "/healthz"
  tags                       = var.tags
}

module "compute" {
  source = "../../modules/ec2_instance"

  name_prefix         = local.name_prefix
  environment         = var.environment
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.app_sg.security_group_id]
  target_group_arns   = [module.alb.target_group_arn]
  instance_type       = var.instance_type
  ami_id              = var.ami_id
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  root_volume_size_gb = var.root_volume_size_gb
  kms_key_arn         = module.kms.key_arn
  tags                = var.tags
}

module "observability" {
  source = "../../modules/observability"

  name_prefix             = local.name_prefix
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  autoscaling_group_name  = module.compute.autoscaling_group_name
  kms_key_arn             = module.kms.key_arn
  log_retention_days      = var.log_retention_days
  tags                    = var.tags
}
