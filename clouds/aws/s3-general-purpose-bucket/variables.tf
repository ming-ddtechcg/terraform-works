variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project tag"
  type        = string
  default     = "s3-test"
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "enable_public_access" {
  description = "If true, allow public read/write/list access to the bucket via bucket policy. If false, the bucket is private (no public access)."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "If true, allow the bucket to be destroyed even if it contains objects (all objects and object versions are deleted first). Needed for make destroy/clean to work non-interactively."
  type        = bool
  default     = true
}

