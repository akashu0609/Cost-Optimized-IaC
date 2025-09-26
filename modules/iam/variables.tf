variable "env" {
  description = "Environment name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID for IAM conditions"
  type        = string
}

variable "s3_bucket_arn" {
  description = "Target S3 bucket ARN for least-privilege access"
  type        = string
}
