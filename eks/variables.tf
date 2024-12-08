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
