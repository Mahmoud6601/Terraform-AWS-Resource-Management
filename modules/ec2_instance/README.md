# EC2 Compute (Launch Template + ASG) Module

Provisions private-subnet EC2 compute via a hardened Launch Template and Auto Scaling Group with Rolling Instance Refresh:
- Latest Amazon Linux 2023 AMI via SSM Parameter Store (or explicit `ami_id` override).
- Mandatory **IMDSv2** (`http_tokens = "required"`, `http_put_response_hop_limit = 1`).
- Encrypted `gp3` root EBS volume (`ebs_optimized = true`).
- Zero SSH keys or port 22: access exclusively through **AWS SSM Session Manager** (`AmazonSSMManagedInstanceCore`).
- Minimal Nginx `/healthz` verification payload returning IMDSv2 instance metadata.
