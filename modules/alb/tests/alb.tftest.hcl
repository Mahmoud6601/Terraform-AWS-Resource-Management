mock_provider "aws" {}

run "enforces_alb_security_and_tls" {
  command = plan

  variables {
    name_prefix        = "aws-plat-prod"
    vpc_id             = "vpc-12345678"
    subnet_ids         = ["subnet-11111111", "subnet-22222222"]
    security_group_ids = ["sg-11111111"]
    certificate_arn    = "arn:aws:acm:us-east-1:111122223333:certificate/12345678-1234-1234-1234-123456789012"
    health_check_path  = "/healthz"
  }

  assert {
    condition     = aws_lb.this.drop_invalid_header_fields == true
    error_message = "ALB must enable drop_invalid_header_fields."
  }

  assert {
    condition     = length(aws_lb_listener.https) == 1
    error_message = "HTTPS listener must be created when certificate_arn is provided."
  }

  assert {
    condition     = aws_lb_listener.https[0].ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    error_message = "HTTPS listener must use TLS 1.3 security policy."
  }
}
