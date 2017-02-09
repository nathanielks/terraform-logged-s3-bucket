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

variable "bucket_suffix" {
  description = "Additional key to more uniquely identify the bucket name"
  default     = "infra"
}

resource "aws_s3_bucket" "logging" {
  bucket = "${format("%s-%s-%s-logs", var.name, var.environment, var.bucket_suffix)}"
  acl    = "log-delivery-write"
  region = "${var.region}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "mod" {
  bucket = "${format("%s-%s-%s", var.name, var.environment, var.bucket_suffix)}"
  acl    = "private"
  region = "${var.region}"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${aws_s3_bucket.logging.id}"
    target_prefix = "log/"
  }

  tags {
    Environment = "${var.environment}"
  }
}
