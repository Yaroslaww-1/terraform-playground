resource "aws_sqs_queue" "s3_sqs" {
  name                      = "s3-sqs"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sqs_queue" "db_sqs" {
  name                      = "db-sqs"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}