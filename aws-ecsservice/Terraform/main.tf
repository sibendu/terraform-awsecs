module "ecs" {
  source                        = "./modules/ecs"
  project                       = var.project
  environment                   = var.environment
  vpc_id                      = var.vpc_id
  security_group_ids           = var.security_group_ids
  public_subnet_ids              = var.public_subnet_ids
  
}
