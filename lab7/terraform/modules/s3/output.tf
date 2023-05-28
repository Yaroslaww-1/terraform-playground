output "deployment_bucket_id" {
  value = aws_s3_bucket.deployment_bucket.id
}

output "data_bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

output "data_bucket_arn" {
  value = aws_s3_bucket.data_bucket.arn
}
