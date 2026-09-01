module "vpc" {
  source = "../../../modules/vpc"

  vpc_name = "${var.vpc_name}-${var.environment}"
  cidrs    = var.cidrs

  azs                          = var.azs
  private_subnets              = var.private_subnets
  private_subnet_tags          = var.private_subnet_tags
  public_subnets               = var.public_subnets
  public_subnet_tags           = var.public_subnet_tags
  enable_nat_gateway           = var.enable_nat_gateway
  single_nat_gateway           = var.single_nat_gateway
  enable_vpn_gateway           = var.enable_vpn_gateway
  one_nat_gateway_per_az       = var.one_nat_gateway_per_az
  public_dedicated_network_acl = var.public_dedicated_network_acl
  manage_default_network_acl   = var.manage_default_network_acl
  public_inbound_acl_rules     = var.public_inbound_acl_rules
  public_outbound_acl_rules    = var.public_outbound_acl_rules
  tags                         = var.tags
}