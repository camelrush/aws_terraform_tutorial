provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    region = "ap-northeast-1"
    bucket = "tf-tutorial-infra"
    key    = "tf-tutorial.tfstate"
  }
}