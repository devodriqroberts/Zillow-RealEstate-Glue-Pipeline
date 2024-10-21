data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
  
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_policy" {
statement {
    effect    = "Allow"
    actions   = ["s3:GetObject","s3:ListBucket", "s3:PutObject"]
    resources = [
        var.zillow_etl_data_bucket_arn,
        "${var.zillow_etl_data_bucket_arn}/*"
    ]
  }
}

data "archive_file" "lambda" {
  type          = "zip"
  source_dir    = var.path_to_source_folder
  output_path   = var.path_to_output # lambda_function_extract_data.zip
}


resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "zillow-lambda-policy"
  description = "allow lambda to get and list object into the bucket"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_getObject" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "lambda" {
  filename          = var.path_to_output
  function_name     = var.function_name
  role              = aws_iam_role.iam_for_lambda.arn
  handler           = var.function_handler

  memory_size       = var.memory_size
  timeout           = var.timeout

  source_code_hash  = data.archive_file.lambda.output_base64sha256

  runtime           = var.runtime
  layers            = [var.lambda_layer_arn]

  environment {
    variables = {
      API_KEY       = var.rapid_api_key
      API_HOST      = var.rapid_api_host
      DST_BUCKET    = var.zillow_etl_data_bucket
      REGION        = var.aws_region
      RAW_FOLDER    = var.data_loading_zone_key
    }
  }
}

resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "s3.amazonaws.com"

  source_arn    = var.s3_bucket_arn
}