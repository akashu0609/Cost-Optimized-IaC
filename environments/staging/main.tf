terraform {
  required_version = ">= 1.6.0"
  # Optional: remote backend for isolated state
  # backend "s3" {
  #   bucket = "tf-state-staging-1234"
  #   key    = "network/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source              = "../../modules/vpc"
  env                 = "staging"
  cost_center         = "DevOps"
  vpc_cidr            = "10.20.0.0/16"
  public_subnet_cidr  = "10.20.1.0/24"
  private_subnet_cidr = "10.20.2.0/24"
  az                  = "us-east-1a"
}

module "storage" {
  source             = "../../modules/storage"
  env                = "staging"
  bucket_name_suffix = "app-assets-stg"
  cost_center        = "DevOps"
}

module "iam" {
  source          = "../../modules/iam"
  env             = "staging"
  aws_account_id  = "123456789012"
  s3_bucket_arn   = module.storage.bucket_arn
}

module "compute" {
  source              = "../../modules/compute"
  env                 = "staging"
  ami_id              = "ami-xxxxxxxx"       # set a valid AMI
  instance_type       = "t3.micro"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = [module.vpc.public_subnet_id]
  private_subnet_ids  = [module.vpc.private_subnet_id]
  alb_sg_id           = aws_security_group.alb.id
  app_sg_id           = aws_security_group.app.id
}

# Example security groups (minimal)
resource "aws_security_group" "alb" {
  name        = "staging-alb-sg"
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
  name        = "staging-app-sg"
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
