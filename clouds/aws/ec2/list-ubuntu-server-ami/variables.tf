variable "region" {
  description = "Region for the deployment"
  type        = string
  default     = "us-east-2"
}

variable "ubuntu_owner_ids" {
  description = "Owner is Canonical"
  type        = list(string)
  default     = ["099720109477"]
}

variable "ubuntu_versions" {
  description = "Ubuntu version"
  type        = list(string)
  default     = ["20.04", "22.04", "24.04"]
}

variable "arch_type" {
  description = "architectures"
  type        = string
  default     = "amd64"
}

# there is no "desktop" pattern so far in the AMI name
variable "os_targets" {
  description = "OS targets are in desktop or server"
  type        = map(string)
  default = {
    DESKTOP = "desktop"
    SERVER  = "server"
  }
}

variable "most_recent" {
  description = "search the most recent AMI"
  type        = bool
  default     = true
}

