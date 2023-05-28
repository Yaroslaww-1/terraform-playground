data "archive_file" "producer_lambda" {
  type = "zip"

  source_dir  = "${path.module}/../../../producer"
  output_path = "${path.module}/producer.zip"
}

resource "aws_s3_object" "producer_lambda" {
  bucket = var.deployment_bucket_id

  key    = "producer.zip"
  source = data.archive_file.producer_lambda.output_path

  etag = filemd5(data.archive_file.producer_lambda.output_path)
}