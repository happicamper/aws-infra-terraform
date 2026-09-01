module "alb" {
  source = "../../../modules/alb"

  for_each = var.albs

  name                         = each.value.name
  load_balancer_type           = lookup(each.value, "load_balancer_type")
  internal                     = lookup(each.value, "internal")
  vpc_id                       = data.aws_vpc.this.id
  public_subnets               = data.aws_subnets.public.ids
  create_security_group        = var.create_security_group
  security_group_name          = var.security_group_name
  security_group_ingress_rules = each.value.security_group_ingress_rules
  security_group_egress_rules  = each.value.security_group_egress_rules
  security_groups              = null

  enable_deletion_protection = var.enable_deletion_protection

  listeners     = lookup(each.value, "listeners", {})
  target_groups = lookup(each.value, "target_groups", {})

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {})
  )
}

