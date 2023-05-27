## Overview

This is a simple representation of event processing done by multiple AWS services (Api Gateway, Lambda, SQS, S3) and defined using Terraform.

## How To Run

**Prerequisites**: installed terraform, populated aws credentials

1. `cd terraform`
2. `terraform init`
3. `terraform apply` -> copy url and bucket_name from output
4. `curl -X POST -H "Content-Type: application/json" -d '{"key":"val"}' <URL>/`
5. go to aws console > S3 > <BUCKET_NAME> > requests