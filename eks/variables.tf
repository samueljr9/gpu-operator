variable "region" {
  description = "The region where the infrastructure is being deployed"
  type        = string
  default     = "ca-central-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "aws-initiatives"
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "desired_capacity" {
  description = "Desired capacity for the node group"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Maximum capacity for the node group"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Minimum capacity for the node group"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for the node group"
  type        = string
  default     = "c5.large"
}

variable "ebs_volume_size" {
  description = "EBS volume size for the node group"
  type        = number
  default     = 50
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "The list of Availability Zones"
  type        = list(string)
  default     = ["ca-central-1b", "ca-central-1d"]
}

variable "private_subnets" {
  description = "The private subnets"
  type        = list(string)
  default     = ["10.0.6.0/24", "10.0.7.0/24"]
}

variable "public_subnets" {
  description = "The public subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.4.0/24"]
}

variable "common_tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
    Project   = "aws-initiatives"
  }
}

variable "cluster_access_whitelist" {
  description = "List of public IPs allowed to access the cluster endpoint"
  type        = list(string)
  default = [
    "128.129.49.9/32",
    "128.129.49.10/32",
    "128.129.49.11/32",
    "204.107.153.100/32"
  ]
}
