module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Let the module manage aws-auth ConfigMap
  manage_aws_auth_configmap = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.node_group_desired_capacity
      max_capacity     = var.node_group_max_capacity
      min_capacity     = var.node_group_min_capacity
      instance_types   = var.node_group_instance_types

      tags = {
        Name = "${var.cluster_name}-node"
      }
    }
  }

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  tags = var.tags
}
