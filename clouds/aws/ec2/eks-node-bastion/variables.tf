variable "deployment_name" {
  type        = string
  description = "The name of the EKS deployment"
  #default     = "test"
}

variable "region" {
  description = "Region for the deployment"
  type        = string
  default     = "us-east-2"
}

variable "azs" {
  description = "Availability zones for the deployment"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

# Network

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Allow a NAT gateway to enable access from private subnets to the internet."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Set a single shared NAT Gateway across all of private subnets."
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Set a single NAT Gateway per availability zone."
  type        = bool
  default     = false
}

# add: begin
variable "enable_dns_support" {
  description = "Enable the DNS support in VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable the DNS hostname support in VPC."
  type        = bool
  default     = true
}

# EKS node bastion

variable "eks_node_bastion" {
  description = "A bastion to access the EKS nodes"
  type = object({
    instance_type               = string
    key_name                    = optional(string)
    monitoring                  = optional(bool, true)
    associate_public_ip_address = optional(bool)
    create_security_group       = optional(bool, false)
  })
  default = {
    instance_type               = "t3.micro"
    associate_public_ip_address = true
    key_name                    = "mybastion"
  }
}
# add: end

variable "eks_node" {
  description = "A EKS node simulator"
  type = object({
    instance_type               = string
    key_name                    = optional(string)
    monitoring                  = optional(bool, true)
    associate_public_ip_address = optional(bool)
    create_security_group       = optional(bool, false)
  })
  default = {
    instance_type               = "t3.micro"
    associate_public_ip_address = false
    key_name                    = "eks-node"
  }
}

