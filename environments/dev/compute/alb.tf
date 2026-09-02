locals {
  # Injects the prefix_list_id of CloudFront to the ingress_rules so that ALB will only listen from CloudFront.
  albs_merged_ingress = {
    for k, v in var.albs : k => merge(
      lookup(v, "security_group_ingress_rules", {}),
      {
        cloudfront_http = {
          from_port      = 80
          to_port        = 80
          ip_protocol    = "tcp"
          description    = "HTTP from CloudFront only"
          prefix_list_id = data.aws_ec2_managed_prefix_list.cloudfront.id
        }
      }
    )
  }
}

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
  security_group_ingress_rules = local.albs_merged_ingress[each.key]
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

