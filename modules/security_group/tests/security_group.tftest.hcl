mock_provider "aws" {}

run "creates_sg_chained_rules" {
  command = plan

  variables {
    name        = "test-app-sg"
    description = "Private app tier SG"
    vpc_id      = "vpc-12345678"
    ingress_rules = {
      from_alb = {
        description                  = "HTTP from ALB"
        from_port                    = 80
        to_port                      = 80
        protocol                     = "tcp"
        referenced_security_group_id = "sg-87654321"
      }
    }
    egress_rules = {
      https = {
        description = "Outbound HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }

  assert {
    condition     = length(aws_vpc_security_group_ingress_rule.this) == 1
    error_message = "Expected 1 standalone ingress rule."
  }

  assert {
    condition     = length(aws_vpc_security_group_egress_rule.this) == 1
    error_message = "Expected 1 standalone egress rule."
  }
}

run "blocks_unrestricted_ssh" {
  command = plan

  variables {
    name        = "bad-ssh-sg"
    description = "Must fail validation"
    vpc_id      = "vpc-12345678"
    ingress_rules = {
      ssh_world = {
        description = "Bad SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }

  expect_failures = [
    var.ingress_rules
  ]
}
