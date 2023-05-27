resource "aws_s3_bucket" "deployment_bucket" {
  bucket = "ucu-borodaienko-deployment"
}

resource "aws_s3_bucket_acl" "deployment_bucket_acl" {
  bucket = aws_s3_bucket.deployment_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.deployment_bucket_ownership_controls]
}

resource "aws_s3_bucket_ownership_controls" "deployment_bucket_ownership_controls" {
  bucket = aws_s3_bucket.deployment_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "ucu-borodaienko-data"
}

resource "aws_s3_bucket_acl" "data_bucket_acl" {
  bucket = aws_s3_bucket.data_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.data_bucket_ownership_controls]
}

resource "aws_s3_bucket_ownership_controls" "data_bucket_ownership_controls" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}
