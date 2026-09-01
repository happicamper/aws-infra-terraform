module "waf" {
  source = "../../../modules/waf"

  name_prefix            = "dev-app-waf"
  scope                  = "CLOUDFRONT"
  create_alb_association = false
  allow_default_action   = true

  visibility_config = {
    metric_name = "dev-app-waf-main-metrics"
  }

  rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet-rule-1"
      priority        = 1
      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
  ]

  tags = {
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}

module "cdn" {
  source = "../../../modules/cloudfront"

  comment     = "dev-app CloudFront"
  enabled     = true
  price_class = "PriceClass_100"
  web_acl_id  = module.waf.web_acl_arn
  origin = {
    alb = {
      origin_id   = "alb"
      domain_name = data.terraform_remote_state.alb.outputs.alb_dns_att["app"].dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "alb"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_name      = "Managed-CachingOptimized"
    #cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_name = "Managed-AllViewer"
    #origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    response_headers_policy_name = "Managed-CORS-and-SecurityHeadersPolicy"
  }
  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  tags = {
    ManagedBy   = "terraform"
    Environment = "dev"
  }

  depends_on = [
    module.waf
  ]
}