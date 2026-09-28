
output "show_each_ubuntu_servers" {
  value = {
    for version, ami in local.ami_servers : version => {
      id   = ami.id
      name = ami.name
    }
  }
}
