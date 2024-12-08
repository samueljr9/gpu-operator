data "aws_eks_cluster_auth" "cluster_name" {
  name = module.eks.cluster_name
}

# data "aws_iam_policy_document" "alb_controller_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     principals {
#       type        = "Federated"
#       identifiers = [module.eks.oidc_provider_arn]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "${module.eks.cluster_oidc_issuer_url}:sub"
#       values   = ["system:serviceaccount:kube-system:alb-ingress-controller"]
#     }
#   }
# }
