resource "aws_lambda_function" "producer_lambda" {
  function_name = "LambdaProducer"

  s3_bucket = var.deployment_bucket_id
  s3_key    = aws_s3_object.producer_lambda.key

  runtime = "python3.7"
  handler = "producer.lambda_handler"

  source_code_hash = data.archive_file.producer_lambda.output_base64sha256

  environment {
    variables = {
      S3_QUEUE_URL = var.s3_sqs_url
      DB_QUEUE_URL = var.db_sqs_url
    }
  }

  role = aws_iam_role.producer_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "producer_lambda" {
  name = "/aws/lambda/${aws_lambda_function.producer_lambda.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "producer_lambda_exec" {
  name = "producer_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_policy" "sqs_publish_policy" {
  name = "sqs_publish_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [ "sqs:SendMessage" ]
      Effect = "Allow"
      Resource: [var.s3_sqs_arn, var.db_sqs_arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "producer_lambda_policy_sqs" {
  role       = aws_iam_role.producer_lambda_exec.name
  policy_arn = aws_iam_policy.sqs_publish_policy.arn
}

resource "aws_iam_role_policy_attachment" "producer_lambda_policy_basic" {
  role       = aws_iam_role.producer_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
