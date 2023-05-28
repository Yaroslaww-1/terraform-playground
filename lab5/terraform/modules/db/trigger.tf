resource "aws_lambda_event_source_mapping" "db_trigger_sqs" {
  batch_size       = 1
  enabled          = true
  event_source_arn = var.requests_sqs_arn
  function_name    = aws_lambda_function.db_lambda.arn
}