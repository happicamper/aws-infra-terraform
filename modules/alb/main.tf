module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name               = var.name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets

  create_security_group = var.create_security_group
  security_group_name        = var.security_group_name
  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules = var.security_group_egress_rules
  security_groups       = []

  listeners     = var.listeners
  target_groups = var.target_groups
  enable_deletion_protection = var.enable_deletion_protection
  tags = var.tags
}