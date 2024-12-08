output "cert_validation" {
  description = "Wildcard certificate validation information"
  value = [
    for dvo in aws_acm_certificate.wildcard_certificate.domain_validation_options : {
      domain_name  = dvo.domain_name
      record_name  = dvo.resource_record_name
      record_type  = dvo.resource_record_type
      record_value = dvo.resource_record_value
    }
  ]
}

# output "alb_controller_role_arn" {
#   description = "ARN of the IAM role that is being utilized by the deployed controller"
#   value       = module.alb_ingress_controller.aws_iam_role_arn
# }
