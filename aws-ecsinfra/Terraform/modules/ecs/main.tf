data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       =  aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}



resource "aws_launch_configuration" "ziplaunchconfig" {
    image_id             = "ami-0da10b897b6796e40" 
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [var.security_group_id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.project}-${var.environment} >> /etc/ecs/ecs.config"
    instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "zipasg" {

    name                      = "asg-${var.project}-${var.environment}"
    vpc_zone_identifier       = [var.public_subnet_ids[0],var.public_subnet_ids[1]]
    launch_configuration      = aws_launch_configuration.ziplaunchconfig.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 4
    health_check_grace_period = 300
    health_check_type         = "EC2"
    	
  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "zipcapacityprovider" {
  name = "capacityprovider-${var.project}-${var.environment}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.zipasg.arn
    //managed_termination_protection = "ENABLED"

    managed_scaling {
      //maximum_scaling_step_size = 4
      //minimum_scaling_step_size = 1
      status                    = "ENABLED"
      //target_capacity           = 2
    }
  }
}

resource "aws_kms_key" "zipkms" {
  description             = "KMS keys for ZIP APIs"
  deletion_window_in_days = 7
}


resource "aws_cloudwatch_log_group" "ziplogs" {
  name = "logs-${var.project}--${var.environment}"
}

resource "aws_ecs_cluster" "zipcluster" {

  name = "${var.project}-${var.environment}"
  //capacity_providers = [aws_ecs_capacity_provider.zipcapacityprovider.name]
	
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      //kms_key_id = aws_kms_key.zipkms.arn
      logging    = "OVERRIDE"
 
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ziplogs.name
      }
    }
  }
}












