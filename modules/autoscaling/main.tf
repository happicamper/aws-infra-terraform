locals {
  name = coalesce(var.name, "${var.project_name}-${var.environment}-asg")
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.3.0"

  # Autoscaling group
  name = local.name

  min_size          = var.min_size
  max_size          = var.max_size
  desired_capacity  = var.desired_capacity

  vpc_zone_identifier = var.vpc_zone_identifier

  traffic_source_attachments = var.traffic_source_attachments
  
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  # Launch template
  image_id          = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  ebs_optimized     = true
  enable_monitoring = var.enable_monitoring

  security_groups = var.security_group_ids

  user_data = var.user_data != null ? base64encode(var.user_data) : null

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        delete_on_termination = true
        encrypted              = true
        volume_size            = var.root_volume_size
        volume_type             = var.root_volume_type
      }
    }
  ]

  # Enforce IMDSv2 - AWS security best practice
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # IAM role & instance profile
  create_iam_instance_profile = var.create_iam_instance_profile
  iam_role_name               = "${local.name}-role"
  iam_role_path                = "/ec2/"
  iam_role_description         = "IAM role for ${local.name} instances"
  iam_role_policies            = var.iam_role_policies

  instance_refresh = var.instance_refresh_enabled ? {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = var.instance_refresh_min_healthy_percentage
      instance_warmup         = 300
    }
    triggers = ["tag"]
  } : null

  scaling_policies = var.enable_target_tracking ? {
    cpu-target-tracking = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.target_cpu_utilization
      }
    }
  } : {}

  tags = var.tags
}