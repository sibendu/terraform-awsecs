variable "project" {}
variable "environment" {}
variable "cluster_region" {}


variable "public_subnet_ids" {
  description = "subnet ids created in network module"
}

variable "vpc_id" {
  description = "vpc created in network module"
}

variable "keypair" {
  description = "Key Pair we use for all services with EC2"
}

variable "security_group_id" {
  description = "Security group"
}

variable "instance_type" {
  description = "EC2 Instance Type"
}