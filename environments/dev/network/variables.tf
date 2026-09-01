variable "vpc_name" {
  type = string
}

variable "cidrs" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "private_subnet_tags" {
  type = map(string)
  default = {
    Subnet = "private"
  }
}

variable "public_subnets" {
  type = list(string)
}

variable "public_subnet_tags" {
  type = map(string)
  default = {
    Subnet = "public"
  }
}

variable "manage_default_network_acl" {
  type    = bool
  default = true
}
variable "public_dedicated_network_acl" {
  type = bool
}

variable "public_inbound_acl_rules" {
  type = list(map(string))
}

variable "public_outbound_acl_rules" {
  type = list(map(string))
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}