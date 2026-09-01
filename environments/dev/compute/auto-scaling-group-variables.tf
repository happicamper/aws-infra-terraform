variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

# --- Networking (from your VPC / network module or remote state) ---

variable "vpc_id" {
  type = string
}

/*variable "private_subnet_ids" {
  description = "Subnets the ASG instances launch into"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Subnets the ALB launches into"
  type        = list(string)
}

variable "asg_security_group_ids" {
  description = "Security group IDs for the EC2 instances (from modules/security-groups)"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security group IDs for the ALB (from modules/security-groups)"
  type        = list(string)
}*/

# --- ALB ---

variable "alb_certificate_arn" {
  description = "ACM cert for the ALB HTTPS listener. Leave empty to run HTTP only."
  type        = string
  default     = ""
}

# --- ASG / launch template ---

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
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

variable "iam_role_policies" {
  type    = map(string)
  default = {}
}

variable "target_cpu_utilization" {
  type    = number
  default = 50
}