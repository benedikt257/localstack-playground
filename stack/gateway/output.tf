output "url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.api-gateway.id}/${aws_api_gateway_stage.dev_stage.stage_name}/_user_request_/${aws_api_gateway_resource.hello-resource.path_part}"
}