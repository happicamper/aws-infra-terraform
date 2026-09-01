terraform {
  backend "s3" {
    bucket         = "crescendo-tf-state-dev"
    key            = "network/terraform.tfstate"
    use_lockfile   = true
    dynamodb_table = "dynamodb-statelock-dev"
    encrypt        = true
    region         = "ap-southeast-1"

  }
}