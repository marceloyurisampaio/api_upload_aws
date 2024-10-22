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

  integration {
    type                    = "AWS_PROXY"
    http_method             = "POST"
    integration_http_method = "POST"
    uri                     = lambda-api-upload-marcelo-v1.file_processor.invoke_arn  # Integra a Lambda
  }
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

  integration {
    type                    = "AWS_PROXY"
    http_method             = "GET"
    integration_http_method = "GET"
    uri                     = lambda-api-upload-marcelo-v1.file_processor.invoke_arn
  }
}

resource "aws_api_gateway_deployment" "file_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.file_api.id
  stage_name  = "dev"  # Ambiente de desenvolvimento
}
