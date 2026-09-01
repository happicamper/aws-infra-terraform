terraform {
  backend "s3" {
    bucket         = "crescendo-tf-state-dev"
    key            = "compute/terraform.tfstate"
    use_lockfile   = true
    dynamodb_table = "dynamodb-statelock-dev"
    encrypt        = true
    region         = "ap-southeast-1"
  }
}