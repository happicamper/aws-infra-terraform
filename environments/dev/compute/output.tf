output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = data.aws_subnets.public.ids
}

output "autoscaling_group_name" {
  value = module.auto_scaling_group.autoscaling_group_name
}

output "alb_dns_name" {
  value = try(module.alb.dns_name, null)
}

output "asg-sg" {
  value = module.security_group["asg"].sg_security_group_id
}

output "alb_dns_att" {
  value = try(module.alb)
}
