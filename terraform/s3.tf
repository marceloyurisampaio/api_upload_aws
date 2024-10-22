#Definindo a fonte como o Amazon S3
resource "aws_s3_bucket" "upload_bucket" {
  bucket = var.bucket-api-upload-marcelo-v1

# Habilita o versionamento de arquivos no bucket
versioning {
    enabled = true  
}

tags = {
    Name = var.bucket-api-upload-marcelo-v1  # Nome do bucket
    Environment = "dev"     # Tag de ambiente (pode ser prod em produção)
}
}

# Configura a trigger no bucket para acionar a Lambda quando um arquivo for criado
resource "aws_s3_bucket_notification" "s3_lambda_notification" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.file_processor.arn
    events = ["s3:ObjectCreated:*"]  # Aciona quando um arquivo é criado
  }

  depends_on = [aws_lambda_permission.allow_s3_lambda]  # Garante que a permissão Lambda esteja configurada
}
