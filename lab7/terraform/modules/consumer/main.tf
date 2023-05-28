resource "aws_lambda_function" "consumer_lambda" {
  function_name = "LambdaConsumer"

  s3_bucket = var.deployment_bucket_id
  s3_key    = aws_s3_object.consumer_lambda.key

  runtime = "python3.7"
  handler = "consumer.lambda_handler"

  source_code_hash = data.archive_file.consumer_lambda.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = var.data_bucket_name
    }
  }

  role = aws_iam_role.consumer_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "consumer_lambda" {
  name = "/aws/lambda/${aws_lambda_function.consumer_lambda.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "consumer_lambda_exec" {
  name = "consumer_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "sqs_read_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "sqs:Get*",
        "sqs:List*",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      Effect = "Allow"
      Resource: var.requests_sqs_arn
    }]
  })
}

resource "aws_iam_policy" "s3_upload_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [ "s3:*" ]
      Effect = "Allow"
      Resource: "${var.data_bucket_arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "consumer_lambda_policy_sqs" {
  role       = aws_iam_role.consumer_lambda_exec.name
  policy_arn = aws_iam_policy.sqs_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "consumer_lambda_policy_s3" {
  role       = aws_iam_role.consumer_lambda_exec.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}

resource "aws_iam_role_policy_attachment" "consumer_lambda_policy_basic" {
  role       = aws_iam_role.consumer_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
