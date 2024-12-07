terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.aws_initiatives_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.aws_initiatives_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_name.token
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Ensure this points to your kubeconfig file
  }
}
