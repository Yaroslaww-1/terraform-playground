resource "aws_lambda_function" "db_lambda" {
  function_name = "LambdaDb"

  s3_bucket = var.deployment_bucket_id
  s3_key    = aws_s3_object.db_lambda.key

  runtime = "python3.7"
  handler = "db.lambda_handler"

  source_code_hash = data.archive_file.db_lambda.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.db_dynamodb_table.name
    }
  }

  role = aws_iam_role.db_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "db_lambda" {
  name = "/aws/lambda/${aws_lambda_function.db_lambda.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "db_lambda_exec" {
  name = "db_lambda"

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

resource "aws_iam_policy" "dynamodb_write_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [ "dynamodb:*" ]
      Effect = "Allow"
      Resource: aws_dynamodb_table.db_dynamodb_table.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "db_lambda_policy_sqs" {
  role       = aws_iam_role.db_lambda_exec.name
  policy_arn = aws_iam_policy.sqs_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "db_lambda_policy_dynamodb" {
  role       = aws_iam_role.db_lambda_exec.name
  policy_arn = aws_iam_policy.dynamodb_write_policy.arn
}

resource "aws_iam_role_policy_attachment" "db_lambda_policy_basic" {
  role       = aws_iam_role.db_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
