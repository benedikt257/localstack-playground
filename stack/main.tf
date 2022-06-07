data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "lambda" {
    source = "./lambda"
}

module "gateway" {
    source = "./gateway"

    lambda_function = module.lambda.lambda_function

    region = data.aws_region.current.name
    accountId = data.aws_caller_identity.current.account_id
}

output "url" {
  value = module.gateway.url
}