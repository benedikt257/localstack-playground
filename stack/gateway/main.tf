resource "aws_api_gateway_rest_api" "api-gateway" {
  name = "my-first-api-gateway"
}

resource "aws_api_gateway_resource" "hello-resource" {
  parent_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  path_part   = "hello-lambda"
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
}

resource "aws_api_gateway_method" "lambda-method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.hello-resource.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
}

resource "aws_api_gateway_integration" "lambda-integration" {
  rest_api_id             = aws_api_gateway_rest_api.api-gateway.id
  resource_id             = aws_api_gateway_resource.hello-resource.id
  http_method             = aws_api_gateway_method.lambda-method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.api-gateway.id}/*/${aws_api_gateway_method.lambda-method.http_method}${aws_api_gateway_resource.hello-resource.path}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id

  triggers = {
    redeployment = filebase64sha256("${path.module}/main.tf")
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev_stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  stage_name    = "dev"
}