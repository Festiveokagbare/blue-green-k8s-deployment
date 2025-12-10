output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks_cluster.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  value = module.eks_cluster.cluster_security_group_id
}


