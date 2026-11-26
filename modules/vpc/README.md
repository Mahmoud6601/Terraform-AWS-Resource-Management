# VPC Module

Provisions a production-ready multi-AZ AWS VPC with public, private, and optional isolated subnets, Internet Gateway, configurable single or per-AZ HA NAT Gateways, an S3 Gateway Endpoint, encrypted VPC Flow Logs, and a locked-down default security group (CIS AWS Benchmark 5.3).

## Security Controls
- `map_public_ip_on_launch = false` on all subnets.
- `aws_default_security_group` purged to zero ingress/egress rules.
- VPC Flow Logs capture `ALL` traffic into a KMS-encrypted CloudWatch Log Group with explicit retention.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | required | Resource name prefix |
| `cidr` | `string` | required | VPC IPv4 CIDR block |
| `azs` | `list(string)` | required | Availability Zones (minimum 2) |
| `public_subnets` | `list(string)` | required | Public subnet CIDRs |
| `private_subnets` | `list(string)` | required | Private subnet CIDRs |
| `isolated_subnets` | `list(string)` | `[]` | Isolated subnet CIDRs |
| `enable_nat_gateway` | `bool` | `true` | Enable NAT Gateways for private egress |
| `single_nat_gateway` | `bool` | `false` | Share one NAT GW (`true` for dev cost control) |
| `enable_flow_logs` | `bool` | `true` | Enable VPC Flow Logs |
| `flow_log_retention_days` | `number` | `30` | CloudWatch Log Group retention |
| `kms_key_arn` | `string` | `null` | KMS key ARN for Flow Logs encryption |
| `tags` | `map(string)` | `{}` | Additional tags |
