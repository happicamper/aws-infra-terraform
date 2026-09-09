data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "homelab-s3-tf-statefiles-ap-southeast-1"
    key    = "compute/terraform.tfstate"
    region = "ap-southeast-1"
  }
}