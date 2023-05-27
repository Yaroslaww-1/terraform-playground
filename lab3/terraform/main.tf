terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-central-1"
}

module "s3" {
  source = "./modules/s3"
}

module "sqs" {
  source = "./modules/sqs"
}

module "producer" {
  source = "./modules/producer"

  requests_sqs_url = module.sqs.url
  requests_sqs_arn = module.sqs.arn
  deployment_bucket_id = module.s3.deployment_bucket_id
}

module "consumer" {
  source = "./modules/consumer"

  requests_sqs_arn = module.sqs.arn
  deployment_bucket_id = module.s3.deployment_bucket_id
  data_bucket_arn = module.s3.data_bucket_arn
  data_bucket_name = module.s3.data_bucket_name
}