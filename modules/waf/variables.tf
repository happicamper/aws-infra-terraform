variable "name_prefix" {
    type = string
}
variable "scope" {
    type = string
}

variable "create_alb_association" {
    type = bool
}

variable "allow_default_action" {
    type = bool
}

variable "visibility_config" {
    type = map(string)
}

variable "rules" {
    type = any
}
  
variable "tags" {
    type = map(string)
}