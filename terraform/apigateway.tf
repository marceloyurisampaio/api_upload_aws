resource "aws_api_gateway_rest_api" "file_api" {
  name        = "File API"
  description = "API for file upload and retrieval"
}

resource "aws_api_gateway_resource" "upload_resource" {
  rest_api_id = aws_api_gateway_rest_api.file_api.id
  parent_id   = aws_api_gateway_rest_api.file_api.root_resource_id
  path_part   = "upload"  # Caminho /upload
}

resource "aws_api_gateway_method" "upload_method" {
  rest_api_id   = aws_api_gateway_rest_api.file_api.id
  resource_id   = aws_api_gateway_resource.upload_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.file_api.id
  resource_id             = aws_api_gateway_resource.upload_resource.id
  http_method             = aws_api_gateway_method.upload_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_processor.invoke_arn
}

# Rota para listagem de arquivos
resource "aws_api_gateway_resource" "files_resource" {
  rest_api_id = aws_api_gateway_rest_api.file_api.id
  parent_id   = aws_api_gateway_rest_api.file_api.root_resource_id
  path_part   = "files"  # Caminho /files
}

resource "aws_api_gateway_method" "files_method" {
  rest_api_id   = aws_api_gateway_rest_api.file_api.id
  resource_id   = aws_api_gateway_resource.files_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.file_api.id
  resource_id             = aws_api_gateway_resource.files_resource.id
  http_method             = aws_api_gateway_method.files_method.http_method
  integration_http_method = "POST"  # A Lambda sempre usa o método POST na integração, mesmo que o método HTTP seja GET
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_processor.invoke_arn  # Referência à função Lambda
}

resource "aws_api_gateway_deployment" "file_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.file_api.id
  stage_name  = "dev"  # Ambiente de desenvolvimento
}
