############################################
# VPC OUTPUTS
############################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_cidr_block" {
  value = module.vpc.cidr_block
}

############################################
# EKS OUTPUTS (v18.x SAFE)
############################################

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

data "aws_caller_identity" "current" {}

output "cluster_arn" {
  value = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks.cluster_id}"
}
