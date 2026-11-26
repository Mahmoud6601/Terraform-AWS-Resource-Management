# ALB Module

Provisions a hardened Application Load Balancer (`drop_invalid_header_fields = true`, optional S3 access logs, TLS 1.3 HTTPS listener with HTTP->HTTPS 301 redirect when `certificate_arn` is set) and a `/healthz` Target Group.
