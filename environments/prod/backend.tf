terraform {
  backend "s3" {
    bucket         = "tf-state-prod-akash"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-locks-prod"
    encrypt        = true
  }
}
