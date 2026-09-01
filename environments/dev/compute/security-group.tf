locals {
  security_groups = {
    for sg_key, sg in var.security_groups : sg_key => merge(sg, {
      ingress_rules = {
        for rule_key, rule in lookup(sg, "ingress_rules", {}) : rule_key => (
          can(regex("^ALB:", coalesce(lookup(rule, "referenced_security_group_id", null), "")))
          ? merge(rule, {
            referenced_security_group_id = module.alb[split(":", rule.referenced_security_group_id)[1]].security_group_id
          })
          : rule
        )
      }
    })
  }
}

module "security_group" {
  source = "../../../modules/security-groups"

  for_each = local.security_groups

  name            = each.value.name
  description     = each.value.description
  vpc_id          = data.aws_vpc.this.id
  use_name_prefix = var.use_name_prefix
  ingress_rules   = lookup(each.value, "ingress_rules", {})
  egress_rules    = lookup(each.value, "egress_rules", {})

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {})
  )
}

/*module "security_group" {
  source = "../../../modules/security-groups"

  for_each = var.security_groups

  name            = each.value.name
  description     = each.value.description
  vpc_id          = data.aws_vpc.this.id
  use_name_prefix = var.use_name_prefix
  ingress_rules   = lookup(each.value, "ingress_rules", {})
  egress_rules    = lookup(each.value, "egress_rules", {})

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {})
  )

  depends_on = [
    module.alb
  ]
}*/