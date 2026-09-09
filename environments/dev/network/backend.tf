terraform {
  backend "s3" {
    bucket         = "homelab-s3-tf-statefiles-ap-southeast-1"
    key            = "network/terraform.tfstate"
    use_lockfile   = true
    dynamodb_table = "dynamodb-statelock-dev"
    encrypt        = true
    region         = "ap-southeast-1"

  }
}