variable "comment" {
  type = string
}

variable "enabled" {
  type = bool
}

variable "price_class" {
  type = string
}

variable "web_acl_id" {
  type = string
}

variable "origin" {
  type = map(object({
    connection_attempts = optional(number)
    connection_timeout  = optional(number)
    custom_origin_config = optional(object({
      http_port                = number
      https_port               = number
      ip_address_type          = optional(string)
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
      origin_protocol_policy   = string
      origin_ssl_protocols     = optional(list(string), ["TLSv1.2"])
    }))
    domain_name               = string
    origin_access_control_key = optional(string)
    origin_access_control_id  = optional(string)
    origin_id                 = optional(string)
    origin_path               = optional(string)
    response_completion_timeout = optional(number)
  }))
}

variable "default_cache_behavior" {
  type = object({
    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cache_policy_id           = optional(string)
    cache_policy_key          = optional(string)
    cache_policy_name         = optional(string)
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    compress                  = optional(bool, true)
    default_ttl               = optional(number)
    field_level_encryption_id = optional(string)
    forwarded_values = optional(object({
      cookies = object({
        forward           = optional(string, "none")
        whitelisted_names = optional(list(string))
      })
      headers                 = optional(list(string))
      query_string            = optional(bool, false)
      query_string_cache_keys = optional(list(string))
      }),
      {
        cookies = {
          forward = "none"
        }
        query_string = false
      }
    )
    max_ttl                      = optional(number)
    min_ttl                      = optional(number)
    origin_request_policy_id     = optional(string)
    origin_request_policy_key    = optional(string)
    origin_request_policy_name   = optional(string)
    realtime_log_config_arn      = optional(string)
    response_headers_policy_id   = optional(string)
    response_headers_policy_key  = optional(string)
    response_headers_policy_name = optional(string)
    smooth_streaming             = optional(bool)
    target_origin_id             = string
    trusted_key_groups           = optional(list(string))
    trusted_signers              = optional(list(string))
    viewer_protocol_policy       = optional(string, "https-only")
  })
}
  
variable "viewer_certificate" {
  type = object({
    acm_certificate_arn            = optional(string)
    cloudfront_default_certificate = optional(bool)
    iam_certificate_id             = optional(string)
    minimum_protocol_version       = optional(string, "TLSv1.2_2025")
    ssl_support_method             = optional(string)
  })
}

variable "tags" {
  type = map(string)
}