provider "aws" {
  region = "eu-central-1"
}

module "stack" {
  source = "./stack"
}
