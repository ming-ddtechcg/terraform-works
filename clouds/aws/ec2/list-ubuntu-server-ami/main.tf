data "aws_ami" "ubuntu_servers" {
  for_each    = toset(var.ubuntu_versions)
  most_recent = var.most_recent
  owners      = var.ubuntu_owner_ids

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-*-${each.key}-${var.arch_type}-${var.os_targets["SERVER"]}-*"]
  }
}

locals {
  ami_servers = {
    for version, ami in data.aws_ami.ubuntu_servers : version => {
      id   = ami.id
      name = ami.name
    }
  }
}
