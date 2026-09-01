module "auto_scaling_group" {
  source = "../../../modules/autoscaling"

  project_name = var.project_name
  environment  = var.environment

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = file("${path.module}/scripts/bootstrap.sh")

  vpc_zone_identifier = data.aws_subnets.private.ids #var.private_subnet_ids

  # Attaches ASG to the target group for load balancing
  traffic_source_attachments = {
    app = {
      traffic_source_identifier = module.alb["app"].target_groups["app"].arn
      traffic_source_type       = "elbv2"
    }
  }


  security_group_ids = [
    module.security_group["asg"].sg_security_group_id
  ]

  # Launch Template
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_type = "ELB"

  iam_role_policies = var.iam_role_policies

  target_cpu_utilization = var.target_cpu_utilization

  tags = var.tags

  depends_on = [
    module.security_group
  ]
}