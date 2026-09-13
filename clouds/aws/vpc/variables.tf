variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Two availability zones to spread the public/private subnets across"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets (one per availability zone)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the two private subnets (one per availability zone)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "public_ingress_ports" {
  description = "TCP ports to open for public (0.0.0.0/0) inbound access on the public security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "environment" {
  description = "Environment tag (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project tag"
  type        = string
  default     = "vpc-test"
}
