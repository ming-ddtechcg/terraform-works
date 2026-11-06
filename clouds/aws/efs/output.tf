output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "efs_dns_name" {
  value = aws_efs_file_system.this.dns_name
}

output "efs_mount_targets" {
  value = { for az, mt in aws_efs_mount_target.this : az => mt.ip_address }
}

output "efs_access_point_id" {
  value = aws_efs_access_point.this.id
}
