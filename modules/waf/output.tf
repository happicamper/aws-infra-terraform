output "web_acl_arn" {
  description = "ARN of the WAFv2 WebACL"
  value       = module.waf.web_acl_arn   # pass-through from the inner registry module
}