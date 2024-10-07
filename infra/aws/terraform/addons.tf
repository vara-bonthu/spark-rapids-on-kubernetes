# TODO: Add FluentBit, Prometheus & Grafana and Spark History Server

#---------------------------------------------------------------
# Data on EKS Kubernetes Addons
#---------------------------------------------------------------
module "eks_data_addons" {
  source  = "aws-ia/eks-data-addons/aws"
  version = "~> 1.30" # ensure to update this to the latest/desired version

  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_nvidia_device_plugin = true
  nvidia_device_plugin_helm_config = {
    version = "v0.16.2"
    name    = "nvidia-device-plugin"
    values = [
      <<-EOT
        gfd:
          enabled: true
        nfd:
          worker:
            tolerations:
              - key: nvidia.com/gpu
                operator: Exists
                effect: NoSchedule
              - operator: "Exists"
      EOT
    ]
  }

  enable_spark_operator = true
  spark_operator_helm_config = {
    version = "2.0.1"
  }

  enable_yunikorn = var.enable_yunikorn
  yunikorn_helm_config = {
    version = "1.6.0"
  }

  enable_volcano = var.enable_volcano

}