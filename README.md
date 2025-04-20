# Password Generator

A serverless password generator service built with Python aimed to host on AWS Lambda. This service generates secure, random passwords with consistent, yet configurable length and format. Example how passwords will look like using default parameters:
```
HhAeSmOk-WLUWwisB-SvrjFNI2-5jeTkDSC
WEABkXkD-Ey99Gi5Z-JQsAVGkK-7nWxmgbZ
ndpFQ8nW-b6n5hHJb-WW806O7G-biHs6dDe
```


## Features

The service is very useful as self-hosted function that will cost you nothing for day-to-day usage. It will generate passwords using predictable format and (optionally) save them for a short period of time in DynamoDB in case you used it and forgot to save it.

DynamoDB does not have backups enabled and the default TTL is 1h, so make sure to quickly retrieve it in case it got lost. For more details about TTL in DynamoDB, see the [official documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html). This integration is optional and can be controlled via `lambda_var_save_to_ddb` variable.

Both length and number of individual segments can be controlled using `lambda_var_str_length` and `lambda_var_str_count` respectively.

Finally, to integrate with your shell of choice Terraform output will provide you with an easy to use alias that you can include into your run commands (eg. `~/.bashrc` or `~/.zshrc`). Using `awscurl` is recommended for seamless authorization with IAM credentials. Once integrated, running `pwdgen` will result with password in your terminal, as well as it being saved to DynamoDB for a short duration.


## Architecture

The service is built using:
- AWS Lambda for serverless execution
- AWS Lambda Function URL for public availability
- Optional DynamoDB integration for short-term password storage
- Terraform for IaC

## Prerequisites

- AWS account with appropriate permissions
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with appropriate credentials
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed (version ~> 1.10)
- [awscurl](https://github.com/okigan/awscurl?tab=readme-ov-file#installation) installed (version ~> 0.36)

## Installation

1. Clone the repository:
```bash
git clone git@github.com:ViktorPavkovic/password-generator.git
```

2. Initialize Terraform:
```bash
cd password-generator/infrastructure
terraform init
```

3. Deploy the infrastructure:
```bash
terraform apply
```

## Configuration

The service can be configured using environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `STR_LENGTH` | Length of each password segment | 8 |
| `STR_COUNT` | Number of segments in the password | 4 |
| `SAVE_TO_DDB` | Whether to store passwords in DynamoDB | false |
| `TTL` | (Optional) Time-to-live for stored passwords (in seconds) | 3600 |
| `DDB_TABLE` | DynamoDB table name for password storage | `pwdgen-prod` |

## Usage

### HTTP API

AWS Lambda has function URL defined using AWS IAM authorization. It can be invoked using either `curl` with self-managed AWS Sigv4, or `awscurl` wrapper which is recommended for seamless signing of requests:

```bash
awscurl --region <aws-region> --service lambda https://<lambda-url>
```
Once Terraform is applied, custom alias will be generated that you can use with your local shell.

## Infrastructure

The infrastructure is managed using Terraform and includes:
- Lambda function with function URL
- IAM roles and policies
- DynamoDB table (optional)
- CloudWatch logs

Using a remote state in S3 is recommended, refer to `infrastructure/_provider.tf` for configuration.


### Terraform Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region to deploy to | eu-central-1 |
| `environment` | Environment name (dev, prod) | dev |
| `project_name` | Name of the project | password-generator |


## Cost
The entire infrastructure is within AWS Free Tier, but costs may be incurred if usage exceeds the free tier limits or is otherwise unexpectedly high. In an average scenario cold Lambda will execute in ~400 ms, while hot will take ~40 ms.

To get more understanding of costs visit AWS pricing pages for [Lambda](https://aws.amazon.com/lambda/pricing/), [DynamoDB](https://aws.amazon.com/dynamodb/pricing/), and [CloudWatch](https://aws.amazon.com/cloudwatch/pricing/).


## License

This project is licensed under the MIT License - see the LICENSE file for details.
