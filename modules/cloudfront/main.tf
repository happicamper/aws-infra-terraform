module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 4.0"

  comment             = var.comment
  enabled             = var.enabled
  price_class         = var.price_class
  web_acl_id          = var.web_acl_id

  origin = var.origin

  default_cache_behavior = var.default_cache_behavior
  
  viewer_certificate = var.viewer_certificate

  tags = var.tags
}