# VPC
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.2"

  name = "${var.deployment_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  #intra_subnets   = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 52)]

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = local.tags
}

# module "endpoints" {
#   source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "~> 6.7"
#
#   vpc_id             = module.vpc.vpc_id
#   security_group_ids = [aws_security_group.node_ssh.id]
#
#   endpoints = {
#     # Gateway Endpoint (SSH)
#     ssh = {
#       service      = "ssh"
#       service_type = "Gateway"
#       route_table_ids = concat(
#         module.vpc.private_route_table_ids,
#         module.vpc.public_route_table_ids
#       )
#       tags = merge(local.tags, {
#         Name = "${local.name}-ssh-gateway-endpoint"
#       })
#     },
#
#     # Interface Endpoint (ECR API)
#     ecr_api = {
#       service             = "ecr.api"
#       private_dns_enabled = true
#       subnet_ids          = module.vpc.private_subnets
#       tags = merge(local.tags, {
#         Name = "${local.name}-ecr-api-interface"
#       })
#     }
#   }
#
#   tags = merge(local.tags, {
#     Name = "${local.name}-vpc-endpoint"
#   })
# }
