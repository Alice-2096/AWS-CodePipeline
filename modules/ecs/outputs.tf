output "ecs_cluster_name" {
  value       = aws_ecs_cluster.nyu-al-ecs-cluster.name
  description = "The name of the ECS cluster"
}
output "ecs_service_name" {
  value       = aws_ecs_service.nyu-al-ecs-service.name
  description = "The name of the ECS service"
}
