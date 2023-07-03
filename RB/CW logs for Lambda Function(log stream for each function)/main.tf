resource "aws_cloudwatch_log_group" "main" {
  name = var.log_group_name

  tags = {
    Name = "RB's Log Group"
  }
}

resource "aws_lambda_function" "main" {
  function_name    = var.lambda_function_name
  handler          = "index.handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda.arn
  timeout          = 60
  memory_size      = 128
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      AWS_LAMBDA_LOG_GROUP_NAME   = aws_cloudwatch_log_group.main.name
      AWS_LAMBDA_LOG_STREAM_NAME  = var.log_stream_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.main,
  ]

  tags = {
    Name = "RB's Lambda Function"
  }
}
