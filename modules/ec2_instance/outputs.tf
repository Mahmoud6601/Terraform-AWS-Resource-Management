output "launch_template_id" {
  description = "ID of the hardened EC2 Launch Template."
  value       = aws_launch_template.this.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group."
  value       = aws_autoscaling_group.this.arn
}

output "iam_role_arn" {
  description = "ARN of the EC2 IAM Role attached via Instance Profile."
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_name" {
  description = "Name of the EC2 IAM Instance Profile."
  value       = aws_iam_instance_profile.this.name
}
