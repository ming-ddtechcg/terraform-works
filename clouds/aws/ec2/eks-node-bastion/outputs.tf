output "bastion_host" {
  value = "${module.ec2_bastion.public_ip} - ${module.ec2_bastion.public_dns}"
}

output "eks_node_host" {
  value = "${module.ec2_eks_node.private_ip} - ${module.ec2_eks_node.private_dns}"
}
