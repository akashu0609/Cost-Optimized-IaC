terraform {
  backend "s3" {
    bucket         = "tf-state-dev-akash"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-locks-dev"
    encrypt        = true
  }
}
