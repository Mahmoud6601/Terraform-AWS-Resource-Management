# Security Group Module

Manages an AWS Security Group using standalone `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` resources with `create_before_destroy` lifecycle protection and SG-to-SG chaining support.

## Guardrails
- Built-in Terraform variable validation rejects any `0.0.0.0/0` ingress rule covering port `22` (SSH) or `3389` (RDP).
- Requires an explicit description on the security group and every rule.
