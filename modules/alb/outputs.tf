output "security_group_id" {
  value = aws_security_group.alb.id
}
output "target_group_arn" {
  value = aws_lb_target_group.target_group[*].arn
}
output "target_group_name" {
  value = aws_lb_target_group.target_group[*].name
}
output "alb_dns_name" {
  value = aws_alb.application_load_balancer.dns_name
}
output "listener_arn" {
  value = aws_lb_listener.listener[*].arn
}
