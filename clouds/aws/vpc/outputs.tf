output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}

output "public_security_group_id" {
  description = "The ID of the public-access security group"
  value       = aws_security_group.public.id
}
