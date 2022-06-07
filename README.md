# Localstack Playground

This project is just a playground for playing around with Localstack and Terraform.

## Prerequisites
The following must be installed:
* Python 3
* Terraform
* Docker

## Instructions

Set up `localstack` (see https://docs.localstack.cloud/get-started/ for details)

```shell
python -m venv ./venv
source ./venv/bin/activate
pip install localstack
localstack start
```
and wait for the stack to come online.

Afterwards, deploy the stack:
```shell
cd localstack
terraform apply --auto-approve
```

The output variable points to the REST API method triggering the lambda, e.g.:
```shell
Outputs:

url = "http://localhost:4566/restapis/88pmt1ixac/dev/_user_request_/hello-lambda"
```
