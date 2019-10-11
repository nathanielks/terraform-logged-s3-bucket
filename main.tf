variable "name" {
  description = "the name of your stack, e.g. \"segment\". Prefixed to bucket name"
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod-west\""
}

variable "region" {
  description = "the AWS region in which resources are created"
  default     = "ca-central-1"
}

variable "force_destroy" {
  default = false
}

resource "aws_s3_bucket" "logging" {
  bucket = format("%s-logs", var.name)
  acl    = "log-delivery-write"
  region = var.region

  force_destroy = var.force_destroy

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "mod" {
  bucket = var.name
  acl    = "private"
  region = var.region

  force_destroy = var.force_destroy

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.logging.id
    target_prefix = "log/"
  }

  tags = {
    Environment = var.environment
  }
}

output "name" {
  value = aws_s3_bucket.mod.id
}

output "arn" {
  value = aws_s3_bucket.mod.arn
}

output "domain" {
  value = aws_s3_bucket.mod.bucket_domain_name
}

output "logging_name" {
  value = aws_s3_bucket.logging.id
}

output "logging_arn" {
  value = aws_s3_bucket.logging.arn
}

output "logging_domain" {
  value = aws_s3_bucket.logging.bucket_domain_name
}

