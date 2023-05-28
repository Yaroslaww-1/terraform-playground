output "db_url" {
  value = aws_sqs_queue.db_sqs.url
}

output "db_arn" {
  value = aws_sqs_queue.db_sqs.arn
}

output "s3_url" {
  value = aws_sqs_queue.s3_sqs.url
}

output "s3_arn" {
  value = aws_sqs_queue.s3_sqs.arn
}
