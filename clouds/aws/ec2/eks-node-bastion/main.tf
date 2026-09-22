data "aws_availability_zones" "available" {
}

locals {
  tags = {
    Deployment = var.deployment_name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

