variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_role_name" {
  type        = string
  description = "EKS cluster role name"
}

variable "worker_role_name" {
  type        = string
  description = "EKS worker role name"
}

variable "lambda_role_name" {
  type        = string
  description = "Lambda functions role"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(any)
  description = "Subnet IDs"
}

variable "desired_size" {
  type        = string
  description = "Scaling desired size"
}

variable "max_size" {
  type        = string
  description = "Scaling max size"
}

variable "min_size" {
  type        = string
  description = "Scaling min size"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "instance_types" {
  type        = list(any)
  description = "Instance types"
}

variable "map_roles" {
  type        = list(any)
  description = "Role authorization map"
  default     = []
}
