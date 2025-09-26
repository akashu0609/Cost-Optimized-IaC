variable "env" {}
variable "ami_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "alb_sg_id" {}
variable "app_sg_id" {}
