/*output "target_group_arns" {
  description = "target_group_arns"
  value       = module.alb.target_group_arns
}*/

output "security_group_id" {
  value = module.alb.security_group_id
}

output "arn" {
  description = "ARN of the load balancer"
  value       = module.alb.arn
}

output "dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb.target_groups
}