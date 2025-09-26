variable "env" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "cost_center" {
  description = "Tag for cost tracking"
  type        = string
  default     = "DevOps"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}
