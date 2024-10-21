resource "aws_cloudwatch_event_rule" "schedule" {
  name        = var.schedule_name
  description = "Schedule for Lambda Function"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "processing_lambda"
  arn       = var.processing_lambda_arn
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = var.processing_lambda_function_name
    principal = "events.amazonaws.com"
}