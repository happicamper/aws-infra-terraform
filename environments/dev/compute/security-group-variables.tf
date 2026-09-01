variable "security_groups" {
  description = "Map of security groups to create"
  type = map(object({
    name        = string
    description = string

    ingress_rules = optional(map(object({
      from_port                    = optional(number)
      to_port                      = optional(number)
      ip_protocol                  = string
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      referenced_security_group_id = optional(string)
      prefix_list_id               = optional(string)
      description                  = optional(string)
    })), {})

    egress_rules = optional(map(object({
      from_port                    = optional(number)
      to_port                      = optional(number)
      ip_protocol                  = string
      cidr_ipv4                    = optional(string)
      cidr_ipv6                    = optional(string)
      referenced_security_group_id = optional(string)
      prefix_list_id               = optional(string)
      description                  = optional(string)
    })), {})

    tags = optional(map(string), {})
  }))
}

variable "tags" {
  type = map(string)
}

variable "use_name_prefix" {
  type = bool
}

variable "vpc_name" {
  type = string
}