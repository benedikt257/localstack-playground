resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda_payload" {
  type = "zip"
  source_file = "${path.module}/lambda.py"
  output_path = "${path.module}/payload.zip"
}

resource "aws_lambda_function" "hello_lambda" {
  filename      = "${path.module}/payload.zip"
  function_name = "hello-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"

  source_code_hash = data.archive_file.lambda_payload.output_base64sha256

  runtime = "python3.9"

  depends_on = [
    data.archive_file.lambda_payload
  ]
}
