module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  version                       = "~>5.16.0"
  name                          = "aws-initiatives-vpc"
  cidr                          = var.cidr
  azs                           = var.azs
  private_subnets               = var.private_subnets
  public_subnets                = var.public_subnets
  map_public_ip_on_launch       = true
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_support            = true
  enable_dns_hostnames          = true
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  tags                          = var.common_tags
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~>20.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids = concat(
    module.vpc.private_subnets,
    module.vpc.public_subnets
  )

  authentication_mode             = "API_AND_CONFIG_MAP"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Update this list with Zscaler provided IPs
  cluster_endpoint_public_access_cidrs = var.cluster_access_whitelist

  cluster_addons = {
    aws-ebs-csi-driver = { most_recent = true }
  }

  eks_managed_node_groups = {
    initiatives-main-ng = {
      name                         = "initiatives-main-ng"
      ami_type                     = "AL2023_x86_64_STANDARD"
      instance_types               = [var.instance_type]
      min_size                     = var.min_size
      max_size                     = var.max_size
      desired_size                 = var.desired_capacity
      iam_role_additional_policies = { AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" }
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.ebs_volume_size
            volume_type           = "gp2"
            delete_on_termination = true
          }
        }
      ]
    }

    initiatives-gpu-ng = {
      name                         = "initiatives-gpu-ng"
      ami_type                     = "AL2_x86_64_GPU"
      instance_types               = ["g4dn.xlarge"]
      capacity_type                = "ON_DEMAND"
      min_size                     = 0
      max_size                     = 1
      desired_size                 = 1
      tags                         = var.common_tags
      iam_role_additional_policies = { AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" }
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 80
            volume_type           = "gp2"
            delete_on_termination = true
          }
        }
      ]

      labels = {
        gpu = "true"
      }

      taints = {
        dedicated = {
          key    = "gpu"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  tags = var.common_tags
}

resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name = "*.cgi-gma-devsecops.com"

  # The validation requires adding the record from outputs in our DNS
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.common_tags
}

# module "alb_ingress_controller" {
#   source           = "iplabs/alb-ingress-controller/kubernetes"
#   version          = "~>3.4.0"
#   k8s_cluster_type = "eks"
#   k8s_namespace    = "kube-system"
#   aws_region_name  = var.region
#   k8s_cluster_name = module.eks.cluster_name

#   depends_on = [module.eks]
# }

resource "aws_iam_role" "gpu_ng_role" {
  name = "gpu-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.gpu_ng_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.gpu_ng_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# resource "aws_iam_role" "alb_ingress_role" {
#   name               = "alb-ingress-controller-role"
#   assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_policy.json
# }

# resource "aws_iam_policy" "alb_ingress_policy" {
#   name        = "alb-ingress-controller-policy"
#   description = "IAM policy for ALB Ingress Controller"
#   policy      = file("${path.module}/documents/alb_ingress_policy.json")
# }

# resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
#   role       = aws_iam_role.alb_ingress_role.name
#   policy_arn = aws_iam_policy.alb_ingress_policy.arn
# }
