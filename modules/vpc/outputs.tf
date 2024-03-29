output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "security_groups" {
  value = module.vpc.default_security_group_id
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
