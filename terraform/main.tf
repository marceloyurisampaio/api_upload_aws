#Este é o arquivo de orquestração dos demais arquivos. 

# Carrega o provedor AWS configurado no provider.tf
provider "aws" {
  region = "us-east-1"  # Escolha a região que você quer
}

#Definição de variáveis para posterior utilização
variable "bucket-api-upload-marcelo-v1" {
  description = "Bucket para armazenamento dos arquivos no S3"
  type        = string
  default     = "bucket-api-upload-marcelo-v1"
}

variable "lambda-api-upload-marcelo-v1" {
  description = "Função lambda para processamento dos arquivos"
  type        = string
  default     = "lambda-api-upload-marcelo-v1"
}

variable "register-table-api-upload-marcelo-v1" {
  description = "Tabela de registros de uploads no DynamoDB"
  type        = string
  default     = "register-table-api-upload-marcelo-v1"
}

# Inclui o bucket S3 e a notificação de criação de objetos
module "s3" {
  source = "./s3"
}

# Inclui a função Lambda e suas permissões
module "lambda" {
  source = "./lambda"
}

# Inclui a tabela DynamoDB para armazenar os metadados dos arquivos
module "dynamodb" {
  source = "./dynamodb"
}

# Configura o API Gateway para interagir com a função Lambda
module "api_gateway" {
  source = "./apigateway"
}

# Inclui as permissões IAM necessárias para a função Lambda acessar o S3 e DynamoDB
module "iam" {
  source = "./iam"
}

# Outputs para visualização após o apply
output "api_gateway_url" {
  value = aws_api_gateway_rest_api.file_api.execution_arn
  description = "URL da API Gateway"
}
output "bucket-api-upload-marcelo-v1" {
  value = aws_s3_bucket.upload_bucket.bucket
}
output "lambda-api-upload-marcelo-v1" {
  value = aws_lambda_function.file_processor.function_name
}
