terraform {
  required_version = ">= 1.6.0"
  # Optional: remote backend for prod state
  # backend "s3" {
  #   bucket = "tf-state-prod-1234"
  #   key    = "network/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source              = "../../modules/vpc"
  env                 = "prod"
  cost_center         = "DevOps"
  vpc_cidr            = "10.30.0.0/16"
  public_subnet_cidr  = "10.30.1.0/24"
  private_subnet_cidr = "10.30.2.0/24"
  az                  = "us-east-1b"
}

module "storage" {
  source             = "../../modules/storage"
  env                = "prod"
  bucket_name_suffix = "app-assets-prod"
  cost_center        = "FinOps"
}

module "iam" {
  source          = "../../modules/iam"
  env             = "prod"
  aws_account_id  = "123456789012"
  s3_bucket_arn   = module.storage.bucket_arn
}

module "compute" {
  source              = "../../modules/compute"
  env                 = "prod"
  ami_id              = "ami-xxxxxxxx"           # set a hardened AMI
  instance_type       = "t3.small"               # right-sized for prod
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = [module.vpc.public_subnet_id]
  private_subnet_ids  = [module.vpc.private_subnet_id]
  alb_sg_id           = aws_security_group.alb.id
  app_sg_id           = aws_security_group.app.id
}

# Security groups (prod)
resource "aws_security_group" "alb" {
  name        = "prod-alb-sg"
  description = "Allow HTTP from internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "prod-app-sg"
  description = "Allow ALB to reach app instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "alb_dns_name" {
  value = module.compute.alb_dns_name
}
