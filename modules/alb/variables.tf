# ------------------------------------------------------------------
# Define one entry per ALB you want to create.
# Each key becomes the map key (used internally by for_each);
# `name` is the actual AWS load balancer name.
#
# `security_group_keys` references keys from var.security_groups
# (in variables.tf) so the ALB reuses SGs created by module.security_group
# instead of the alb module creating its own.
#
# `listeners` / `target_groups` follow the module's native map format
# (kept as `any` here since they're deeply nested and optional-heavy —
# see the module docs for the full shape of each block).
# ------------------------------------------------------------------
variable "name" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "internal" {
  type = bool
}

variable "vpc_id" {
  type = string
}

variable "create_security_group" {
  type = bool
}

variable "security_group_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "security_group_ingress_rules" {
  type = map(object({
    name = optional(string)

    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(string)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(string)
}))
}

variable "security_group_egress_rules" {
  type = map(object({
    name = optional(string)

    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(string)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(string)
}))
}

variable "target_groups" {
  type = map(object({
    port        = optional(string)
    protocol    = optional(string)
    name_prefix = optional(string)
    tags        = optional(map(string))
    target_type = optional(string)
    target_id   = optional(string)
    create_attachment = optional(bool)
    vpc_id = optional(string) 
  }))
}

variable "listeners" {
  type = map(object({
    alpn_policy                 = optional(string)
    certificate_arn             = optional(string)
    additional_certificate_arns = optional(list(string), [])
    authenticate_cognito = optional(object({
      authentication_request_extra_params = optional(map(string))
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      user_pool_arn                       = optional(string)
      user_pool_client_id                 = optional(string)
      user_pool_domain                    = optional(string)
    }))
    authenticate_oidc = optional(object({
      authentication_request_extra_params = optional(map(string))
      authorization_endpoint              = string
      client_id                           = string
      client_secret                       = string
      issuer                              = string
      on_unauthenticated_request          = optional(string)
      scope                               = optional(string)
      session_cookie_name                 = optional(string)
      session_timeout                     = optional(number)
      token_endpoint                      = string
      user_info_endpoint                  = string
    }))
    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      status_code  = optional(string)
    }))
    forward = optional(object({
      target_group_arn = optional(string)
      target_group_key = optional(string)
    }))
    jwt_validation = optional(object({
      issuer        = string
      jwks_endpoint = string
      additional_claim = optional(list(object({
        format = string
        name   = string
        values = list(string)
      })))
    }))
    weighted_forward = optional(object({
      target_groups = optional(list(object({
        target_group_arn = optional(string)
        target_group_key = optional(string)
        weight           = optional(number)
      })))
      stickiness = optional(object({
        duration = optional(number)
        enabled  = optional(bool)
      }))
    }))
    redirect = optional(object({
      host        = optional(string)
      path        = optional(string)
      port        = optional(string)
      protocol    = optional(string)
      query       = optional(string)
      status_code = string
    }))
    mutual_authentication = optional(object({
      advertise_trust_store_ca_names   = optional(string)
      ignore_client_certificate_expiry = optional(bool)
      mode                             = string
      trust_store_arn                  = optional(string)
    }))
    order    = optional(number)
    port     = optional(number)
    protocol = optional(string)
    ssl_policy = optional(string)
    tags       = optional(map(string), {})
  }))
}

variable "tags" {
  type = map(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type = bool
  default = false
}