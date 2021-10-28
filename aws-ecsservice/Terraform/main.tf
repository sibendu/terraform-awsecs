module "ecs" {
  source                        = "./modules/ecs"
  project                       = var.project
  environment                   = var.environment
  vpc_id                      = var.vpc_id
  security_group_ids           = var.security_group_ids
  public_subnet_ids              = var.public_subnet_ids
  ecs_cluster_name                  = var.ecs_cluster_name
  memory                            = var.memory
  port                           = var.port
  execution_role_arn             = var.execution_role_arn
  task_role_arn                 = var.task_role_arn
  container_image               = var.container_image
  certificate_arn               = var. certificate_arn 
}