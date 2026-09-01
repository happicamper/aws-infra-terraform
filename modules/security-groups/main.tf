module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name            = var.name
  description     = var.description
  vpc_id          = var.vpc_id
  use_name_prefix = var.use_name_prefix

  # Rules defined using the module's "rules" shorthand (protocol/port/cidr etc.)
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules

  tags = var.tags
}
