# IAM role for EC2 instances (app servers)
resource "aws_iam_role" "app_role" {
  name               = "${var.env}-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags = {
    Environment = var.env
  }
}

# Trust policy for EC2 to assume the role
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Least-privilege inline policy for app role (S3 read-only to specific bucket)
data "aws_iam_policy_document" "app_inline" {
  statement {
    sid     = "S3ReadOnlySpecificBucket"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [var.aws_account_id]
    }
  }
}

resource "aws_iam_policy" "app_policy" {
  name   = "${var.env}-app-policy"
  policy = data.aws_iam_policy_document.app_inline.json
}

resource "aws_iam_role_policy_attachment" "app_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}

# Instance profile to attach the role to EC2
resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.env}-app-instance-profile"
  role = aws_iam_role.app_role.name
}
