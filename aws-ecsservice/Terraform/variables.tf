variable "aws_access_key" {
  default = ""
  type    = string
}
variable "aws_secret_key" {
  default = ""
  type    = string
}

# --------------------------------------
# Environment/Project specific variables
# --------------------------------------

variable "project" {
  default = "zip"
  type    = string
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "cluster_region" {
  default = "eu-west-1"
  type    = string
}

variable "vpc_id" {
  default = "vpc-032f89d348b240d16"
  type    = string
}

variable "public_subnet_ids"{
  default = ["subnet-06d2f6ae6524e30f8","subnet-00de4e37057318ccb"]
  type = list
}

variable "security_group_ids"{
  default = ["sg-040b1886355d5d031"]
  type = list
}

variable "ecs_cluster_name"{
  default = "d2b-nonprod"
  type = string
}

variable "memory"{
  default = "256"
  type = string
}


variable "port"{
  default = 8090
  type = number
}

variable "execution_role_arn" {
  default = "arn:aws:iam::729524366783:role/ecsTaskExecutionRole"
  type = string
}

variable "task_role_arn" {
  default = "arn:aws:iam::729524366783:role/ecsTaskExecutionRole"
  type = string
}

variable "container_image" {
  default = "sibendu/subscriptionservice"
  type = string
}

variable "certificate_arn" {
  default = "arn:aws:acm:eu-west-1:729524366783:certificate/5d0a8ed4-cd1a-4c28-9e64-6cdbef0b252d"
  type = string
}



