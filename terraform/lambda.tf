resource "aws_lambda_function" "file_processor" {
  function_name = var.lambda-api-upload-marcelo-v1 
  handler       = "index.handler"           # Função handler principal no código
  runtime       = "nodejs14.x"              # Ambiente de execução da Lambda (Node.js)
  role          = aws_iam_role.lambda_exec.arn

  filename      = "lambda_function.zip"     # Arquivo zipado com o código da Lambda
  source_code_hash = filebase64sha256("lambda_function.zip")  # Hash para detectar mudanças no código

  environment {
    variables = {
      TABLE_NAME = var.register-table-api-upload-marcelo-v1 
    }
  }

  tags = {
    Name = var.lambda-api-upload-marcelo-v1  
    Environment = "dev"              # Ambiente de desenvolvimento
  }
}

# Permissão para Lambda ser acionada pelo S3
resource "aws_lambda_permission" "allow_s3_lambda" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.upload_bucket.arn  # Bucket S3 que invocará a Lambda
}
