variable "env" {
  description = "Environment name"
  type        = string
}

variable "bucket_name_suffix" {
  description = "Unique suffix for bucket name (e.g., app-assets-1234)"
  type        = string
}

variable "cost_center" {
  description = "Tag for cost tracking"
  type        = string
  default     = "DevOps"
}
