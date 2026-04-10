variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "food-delivery"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "ecr_repository_names" {
  description = "ECR repository names to create"
  type        = list(string)
  default     = ["order-service", "restaurant-service", "delivery-service"]
}

variable "node_desired_size" {
  description = "Desired worker node count"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum worker node count"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum worker node count"
  type        = number
  default     = 3
}

variable "node_instance_type" {
  description = "EKS worker node instance type"
  type        = string
  default     = "t3.medium"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    project = "food-delivery"
    env     = "dev"
  }
}
