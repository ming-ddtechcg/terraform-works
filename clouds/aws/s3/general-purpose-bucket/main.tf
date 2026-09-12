resource "aws_s3_bucket" "this" {
  # aws_s3_bucket always provisions a general purpose (regional) bucket,
  # not an S3 Express One Zone directory bucket.
  bucket = var.bucket_name

  # Lets `terraform destroy` (and therefore `make destroy`/`make clean`) delete
  # the bucket even if it still holds objects/object versions.
  force_destroy = var.force_destroy

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  # When enable_public_access is true, the policy/account-level restrictions
  # are left open so the public bucket policy statement below can take effect.
  block_public_acls       = true
  block_public_policy     = var.enable_public_access ? false : true
  ignore_public_acls      = true
  restrict_public_buckets = var.enable_public_access ? false : true
}

data "aws_iam_policy_document" "public" {
  count = var.enable_public_access ? 1 : 0

  statement {
    sid    = "PublicReadWriteList"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.enable_public_access ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.public[0].json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
