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
  default = "zipapi"
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
  default = "vpc-0e8821125d164840c"
  type    = string
}

variable "public_subnet_ids"{
  default = ["subnet-07697392f938bb63e","subnet-012e73f2a7310e3c5"]
  type = list
}

variable "security_group_ids"{
  default = ["sg-0764d713aea317edb"]
  type = list
}
