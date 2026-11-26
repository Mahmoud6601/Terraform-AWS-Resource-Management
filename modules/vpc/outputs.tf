output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC."
  value       = aws_vpc.this.cidr_block
}

output "igw_id" {
  description = "ID of the Internet Gateway attached to the VPC."
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "Ordered list of public subnet IDs."
  value       = [for az in slice(var.azs, 0, length(var.public_subnets)) : aws_subnet.public[az].id]
}

output "private_subnet_ids" {
  description = "Ordered list of private subnet IDs."
  value       = [for az in slice(var.azs, 0, length(var.private_subnets)) : aws_subnet.private[az].id]
}

output "isolated_subnet_ids" {
  description = "Ordered list of isolated subnet IDs."
  value       = [for az in slice(var.azs, 0, length(var.isolated_subnets)) : aws_subnet.isolated[az].id]
}

output "nat_gateway_public_ips" {
  description = "List of Elastic IP addresses associated with the NAT Gateways."
  value       = values(aws_eip.nat)[*].public_ip
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of private route table IDs."
  value       = values(aws_route_table.private)[*].id
}
