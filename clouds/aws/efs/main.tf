resource "aws_efs_file_system" "this" {
  creation_token   = var.efs_name
  encrypted        = true
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode

  tags = merge(var.tags, { Name = var.efs_name })
}

data "aws_subnet" "efs" {
  for_each = var.efs_subnets
  id       = each.value
}

data "aws_vpc" "efs" {
  id = values(data.aws_subnet.efs)[0].vpc_id
}

resource "aws_security_group" "efs" {
  name        = "${var.efs_name}-sg"
  description = "Allow NFS to ${var.efs_name}"
  vpc_id      = data.aws_vpc.efs.id

  tags = merge(var.tags, { Name = "${var.efs_name}-sg" })
}

resource "aws_vpc_security_group_ingress_rule" "efs_nfs" {
  security_group_id = aws_security_group.efs.id
  description       = "NFS from VPC"
  cidr_ipv4         = data.aws_vpc.efs.cidr_block
  ip_protocol       = "tcp"
  from_port         = 2049
  to_port           = 2049
}

resource "aws_efs_mount_target" "this" {
  for_each        = data.aws_subnet.efs
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = var.efs_access_point.uid
    gid = var.efs_access_point.gid
  }

  root_directory {
    path = var.efs_access_point.path
    creation_info {
      owner_uid   = var.efs_access_point.uid
      owner_gid   = var.efs_access_point.gid
      permissions = var.efs_access_point.permissions
    }
  }

  tags = merge(var.tags, { Name = "${var.efs_name}-ap" })
}

resource "aws_efs_file_system_policy" "this" {
  file_system_id = aws_efs_file_system.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowMountAndWriteViaMountTarget"
        Effect    = "Allow"
        Principal = { AWS = "*" }
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
        ]
        Resource = aws_efs_file_system.this.arn
        Condition = {
          Bool = { "elasticfilesystem:AccessedViaMountTarget" = "true" }
        }
      },
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = { AWS = "*" }
        Action    = "*"
        Resource  = aws_efs_file_system.this.arn
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
    ]
  })
}
