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

  db_sqs_url = module.sqs.db_url
  db_sqs_arn = module.sqs.db_arn
  s3_sqs_url = module.sqs.s3_url
  s3_sqs_arn = module.sqs.s3_arn
  deployment_bucket_id = module.s3.deployment_bucket_id
}

module "consumer" {
  source = "./modules/consumer"

  requests_sqs_arn = module.sqs.s3_arn
  deployment_bucket_id = module.s3.deployment_bucket_id
  data_bucket_arn = module.s3.data_bucket_arn
  data_bucket_name = module.s3.data_bucket_name
}

module "db" {
  source = "./modules/db"

  requests_sqs_arn = module.sqs.db_arn
  deployment_bucket_id = module.s3.deployment_bucket_id
}