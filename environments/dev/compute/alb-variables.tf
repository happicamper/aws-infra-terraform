# ------------------------------------------------------------------
# Define one entry per ALB you want to create.
# Each key becomes the map key (used internally by for_each);
# `name` - AWS load balancer name.
#
# `security_group_keys` references keys from var.security_groups
# (in variables.tf) so the ALB reuses SGs created by module.security_group
#
# `listeners` / `target_groups` follow the module's native map format
# (kept as `any` here since they're deeply nested and optional-heavy —
# see the module docs for the full shape of each block).
# ------------------------------------------------------------------
variable "albs" {
  description = "Map of Application Load Balancers to create"
  type = map(object({
    name                         = string
    load_balancer_type           = optional(string, "application")
    internal                     = optional(bool, false)
    subnets                      = list(string)
    security_group_keys          = optional(list(string), [])
    security_group_ingress_rules = optional(any, {})
    security_group_egress_rules  = optional(any, {})
    listeners                    = optional(any, {})
    target_groups                = optional(any, {})
    tags                         = optional(map(string), {})
  }))
}

variable "create_security_group" {
  type = bool
}

variable "security_group_name" {
  type = string
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}