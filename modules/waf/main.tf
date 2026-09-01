module "waf" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "5.1.2"

  name_prefix             = var.name_prefix
  scope                    = var.scope
  create_alb_association   = var.create_alb_association
  allow_default_action     = var.allow_default_action

  visibility_config = var.visibility_config

  rules = var.rules

  tags = var.tags
}