########################################
# VPC MODULE
########################################
module "vpc" {
  source              = "./modules/vpc"
  name                = "bg-demo"
  cidr_block          = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  availability_zones  = var.availability_zones

  tags = {
    Project = "Blue-Green"
    Env     = "prod"
  }
}

########################################
# EKS MODULE
########################################
module "eks" {
  source          = "./modules/eks"

  cluster_name    = "bg-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = {
    Project = "Blue-Green"
    Env     = "prod"
  }
}

