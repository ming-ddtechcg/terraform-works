module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.1"

  name = "${var.deployment_name}-bastion"

  region                      = var.region
  instance_type               = var.eks_node_bastion.instance_type
  key_name                    = var.eks_node_bastion.key_name
  monitoring                  = var.eks_node_bastion.monitoring
  subnet_id                   = module.vpc.public_subnets[0]
  create_security_group       = var.eks_node_bastion.create_security_group
  associate_public_ip_address = var.eks_node_bastion.associate_public_ip_address
  security_group_vpc_id       = module.vpc.default_vpc_id
  vpc_security_group_ids      = [aws_security_group.bastion_ssh.id]

  tags = local.tags
}

module "ec2_eks_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.1"

  name = "${var.deployment_name}-eks-node"

  region                      = var.region
  instance_type               = var.eks_node.instance_type
  key_name                    = var.eks_node.key_name
  monitoring                  = var.eks_node.monitoring
  subnet_id                   = module.vpc.private_subnets[0]
  create_security_group       = var.eks_node.create_security_group
  associate_public_ip_address = var.eks_node.associate_public_ip_address
  security_group_vpc_id       = module.vpc.default_vpc_id
  vpc_security_group_ids      = [aws_security_group.node_ssh.id]

  tags = local.tags
}

