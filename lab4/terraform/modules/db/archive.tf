data "archive_file" "db_lambda" {
  type = "zip"

  source_dir  = "${path.module}/../../../db"
  output_path = "${path.module}/db.zip"
}

resource "aws_s3_object" "db_lambda" {
  bucket = var.deployment_bucket_id

  key    = "db.zip"
  source = data.archive_file.db_lambda.output_path

  etag = filemd5(data.archive_file.db_lambda.output_path)
}