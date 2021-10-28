resource "aws_eip" "nat" {
  count = 1
  vpc   = true
  tags = {
    Name                                        = "${var.project}-${var.environment}"
    project                                     = var.project
    environment                                 = var.environment
  }
}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "3.0.0"
  name                   = "${var.project}-${var.environment}"
  cidr                   = var.vpc_cidr_block
  azs                    = var.vpc_availability_zones
  
  //private_subnets        = [cidrsubnet("${var.vpc_cidr_block}", 3, 0), cidrsubnet("${var.vpc_cidr_block}", 4, 2), cidrsubnet("${var.vpc_cidr_block}", 4, 3), cidrsubnet("${var.vpc_cidr_block}", 4, 4)]
  private_subnets        = [cidrsubnet("${var.vpc_cidr_block}", 3, 0), cidrsubnet("${var.vpc_cidr_block}", 4, 2)]
 	
  public_subnets         = [cidrsubnet("${var.vpc_cidr_block}", 4, 5), cidrsubnet("${var.vpc_cidr_block}", 4, 6)]
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  reuse_nat_ips          = true
  external_nat_ip_ids    = aws_eip.nat.*.id
   
  private_subnet_tags = {   
    net-type = "private"
    Name     = "${var.project}--${var.environment}-pvt-sub"
  }

  public_subnet_tags = {
    net-type = "public"
    Name     = "${var.project}--${var.environment}-pub-sub"
  }

  tags = {
    project                                     = var.project
    environment                                 = var.environment
  }
}



resource "aws_security_group" "zipsg" {
  name        = "sec-${var.project}-${var.environment}"
  description = "Security group for ZIP components"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "HTTPS"
      from_port        = 0
      to_port          = 443
      protocol         = "tcp"
      prefix_list_ids = null
      security_groups = null
      self = null
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
	,
    {
      description      = "TCP"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      prefix_list_ids = null
      security_groups = null
      self = true
      cidr_blocks      = null
      ipv6_cidr_blocks = null
    }
	,
    {
      description      = "UDP"
      from_port        = 0
      to_port          = 65535
      protocol         = "udp"
      prefix_list_ids = null
      security_groups = null
      self = true
      cidr_blocks      = null
      ipv6_cidr_blocks = null
    }
  ]

  egress = [
    {
      description = "" 
      prefix_list_ids = null
      self = null
      security_groups = null
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}