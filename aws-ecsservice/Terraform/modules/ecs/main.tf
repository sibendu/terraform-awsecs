data "aws_ecs_cluster" "zipcluster" {
  cluster_name = var.ecs_cluster_name
}

resource "aws_cloudwatch_log_group" "ziptasklogs" {
  name = "/ecs/task-${var.project}-${var.environment}"
}

resource "aws_ecs_task_definition" "ziptaskdef" {
  family = "taskdef-${var.project}-${var.environment}"
  requires_compatibilities = ["EC2"]
  //cpu = var.cpu
  memory = var.memory 
  network_mode = "host"
  execution_role_arn =  var.execution_role_arn 
  task_role_arn = var.task_role_arn      
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "${var.project}-${var.environment}",
    "image": "${var.container_image}",
    "essential": true,
    "portMappings": [
      {
        "hostPort": ${var.port},
        "containerPort": ${var.port}, 
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "spring.profiles.active",
        "value": "${var.environment}"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/task-${var.project}-${var.environment}",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "ecs"
        }
     } 	
  }
]
TASK_DEFINITION

}

resource "aws_lb_target_group" "ziptg" {
  name     = "tg-${var.project}-${var.environment}"
  target_type = "instance" 
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check{
    enabled = true
    path = "/actuator/health"    
  }
}

resource "aws_lb" "ziplb" {
  name               = "lb-${var.project}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = "${var.security_group_ids}"
  subnets            = "${var.public_subnet_ids}"

  tags = {
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "zip_lb_listener" {
  load_balancer_arn = aws_lb.ziplb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ziptg.arn
  }
}


resource "aws_ecs_service" "zipservice" {

  name = "svc-${var.project}-${var.environment}"
  cluster         = data.aws_ecs_cluster.zipcluster.id
  task_definition = aws_ecs_task_definition.ziptaskdef.arn
  desired_count   = 1
  
  force_new_deployment = true

 // launch_type = "EC2"

 // network_configuration{
 //   subnets = "${var.public_subnet_ids}"
 //   security_groups = "${var.security_group_ids}"
 //   //assign_public_ip = true 
 // }

  	
  load_balancer {
    //elb_name = "${var.project}-${var.environment}-lb"
    target_group_arn = aws_lb_target_group.ziptg.arn
    container_name   = "${var.project}-${var.environment}"
    container_port   = var.port
  }
  
  
}












