output "autoscaling_group_id" {
  value = module.asg.autoscaling_group_id
}

output "autoscaling_group_name" {
  value = module.asg.autoscaling_group_name
}

output "autoscaling_group_arn" {
  value = module.asg.autoscaling_group_arn
}

output "launch_template_id" {
  value = module.asg.launch_template_id
}

output "launch_template_latest_version" {
  value = module.asg.launch_template_latest_version
}

output "iam_role_arn" {
  value = module.asg.iam_role_arn
}
