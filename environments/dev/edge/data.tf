data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "crescendo-tf-state-dev"
    key    = "compute/terraform.tfstate"
    region = "ap-southeast-1"
  }
}