module "network" {
  source                     = "./modules/network"
  project                    = var.project
  environment                = var.environment
  cluster_region             = var.cluster_region
  vpc_cidr_block             = var.vpc_cidr_block
  vpc_availability_zones     = var.vpc_availability_zones
  aws_access_key             = var.aws_access_key
  aws_secret_key             = var.aws_secret_key
}


module "ecs" {
  source                        = "./modules/ecs"
  project                       = var.project
  environment                   = var.environment
  cluster_region                = var.cluster_region
  public_subnet_ids             = module.network.public_subnet_ids
  vpc_id                        = module.network.vpc_id
  keypair                       = var.keypair
  security_group_id             = module.network.security_group_id
}

