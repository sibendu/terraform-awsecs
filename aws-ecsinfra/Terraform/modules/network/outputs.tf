# -------
# Outputs
# --------

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "security_group_id" {
  description = "ID of our private subnet 0curity group"
  value       = aws_security_group.zipsg.id
}

output "public_subnet_ids" {
  description = "List of IDs our public subnets"
  value       = module.vpc.public_subnets
}


output "public_subnet_id" {
  description = "ID of our public subnet 0"
  value       = module.vpc.public_subnets[0]
}

output "private_subnet_ids" {
  description = "List of IDs our private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnet_id" {
  description = "ID of our private subnet 0"
  value       = module.vpc.private_subnets[0]
}

