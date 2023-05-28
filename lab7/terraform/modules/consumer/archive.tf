data "archive_file" "consumer_lambda" {
  type = "zip"

  source_dir  = "${path.module}/../../../consumer"
  output_path = "${path.module}/consumer.zip"
}

resource "aws_s3_object" "consumer_lambda" {
  bucket = var.deployment_bucket_id

  key    = "consumer.zip"
  source = data.archive_file.consumer_lambda.output_path

  etag = filemd5(data.archive_file.consumer_lambda.output_path)
}