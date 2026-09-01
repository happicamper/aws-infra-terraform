variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  description = "Override the generated name (defaults to project_name-environment-asg)"
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# Launch template
# ---------------------------------------------------------------------------

variable "ami_id" {
  description = "AMI to launch instances from"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name (optional - omit if using SSM only)"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs attached to instances (from modules/security-groups)"
  type        = list(string)
}

variable "user_data" {
  description = "Raw (non-base64) user data script"
  type        = string
  default     = null
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

# ---------------------------------------------------------------------------
# Autoscaling group
# ---------------------------------------------------------------------------

variable "vpc_zone_identifier" {
  description = "Subnet IDs the ASG launches instances into"
  type        = list(string)
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "health_check_type" {
  description = "EC2 or ELB"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

# ---------------------------------------------------------------------------
# IAM
# ---------------------------------------------------------------------------

variable "create_iam_instance_profile" {
  type    = bool
  default = true
}

variable "iam_role_policies" {
  description = "Map of policy name => policy ARN to attach to the instance role"
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Instance refresh / scaling policy
# ---------------------------------------------------------------------------

variable "instance_refresh_enabled" {
  type    = bool
  default = true
}

variable "instance_refresh_min_healthy_percentage" {
  type    = number
  default = 90
}

variable "enable_target_tracking" {
  type    = bool
  default = true
}

variable "target_cpu_utilization" {
  type    = number
  default = 50
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "traffic_source_attachments" {
  description = "Map of traffic source attachment definitions to create"
  type = map(object({
    traffic_source_identifier = string
    traffic_source_type       = optional(string, "elbv2")
  }))
  default = null
}