resource "helm_release" "gpu_operator" {
  name             = "gpu-operator"
  namespace        = "gpu-operator"
  repository       = "https://helm.ngc.nvidia.com/nvidia"
  chart            = "gpu-operator"
  version          = "v24.9.0"
  create_namespace = true
  timeout          = 600

  values = [
    file("${path.module}/manifests/gpu-operator-values.yaml") # Path to point to the 'values.yaml' file
  ]

  depends_on = [module.eks]
}

output "gpu_operator_status" {
  value = helm_release.gpu_operator.status
}
