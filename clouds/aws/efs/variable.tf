variable "region" {
  type    = string
  default = "us-east-2"
}

variable "efs_name" {
  type        = string
  description = "the name of EFS"
  default     = "efs-test"
}

variable "efs_performance_mode" {
  type        = string
  description = "EFS performance mode"
  default     = "generalPurpose"
  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.efs_performance_mode)
    error_message = "efs_performance_mode must be generalPurpose or maxIO."
  }
}

variable "efs_throughput_mode" {
  type        = string
  description = "EFS throughtput mode"
  default     = "elastic"
  validation {
    condition     = contains(["bursting", "elastic", "provisioned"], var.efs_throughput_mode)
    error_message = "efs_throughput_mode must be bursting, elastic, or provisioned."
  }
}

variable "tags" {
  description = "Tags to apply to the EFS file system"
  type        = map(string)
  default = {
    Environment = "test"
    ManagedBy   = "terraform"
  }
}

variable "efs_subnets" {
  description = "Subnets to create EFS mount targets in, keyed by availability zone"
  type        = map(string)
  default = {
    "us-east-2a" = "subnet-09d0676ebdf96b9ce"
    "us-east-2b" = "subnet-07faed8247edaf374"
  }
}

variable "efs_access_point" {
  description = "POSIX identity and root directory enforced by the EFS access point"
  type = object({
    path        = string
    uid         = number
    gid         = number
    permissions = string
  })
  default = {
    path        = "/"
    uid         = 1000
    gid         = 1000
    permissions = "0755"
  }
}
