# add: begin
resource "aws_security_group" "node_ssh" {
  name_prefix = "${var.deployment_name}-node-ssh-"
  vpc_id      = module.vpc.vpc_id
  description = "SSH from node/CIDR"

  ingress {
    description = "SSH from node/CIDR inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # scope this down to your actual source
  }

  egress {
    description = "SSH from node/CIDR outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group" "bastion_ssh" {
  name_prefix = "${var.deployment_name}-bastion-ssh-"
  vpc_id      = module.vpc.vpc_id
  description = "SSH from bastion/CIDR"

  ingress {
    description = "SSH from bastion/CIDR inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # scope this down to your actual source
  }

  egress {
    description = "SSH from bastion/CIDR outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

# add: end
