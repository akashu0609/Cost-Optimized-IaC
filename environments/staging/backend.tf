terraform {
  backend "s3" {
    bucket         = "tf-state-staging-akash"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-locks-staging"
    encrypt        = true
  }
}
