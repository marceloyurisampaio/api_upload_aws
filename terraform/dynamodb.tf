resource "aws_dynamodb_table" "files_table" {
  name           = var.register-table-api-upload-marcelo-v1
  billing_mode   = "PAY_PER_REQUEST" # Pagamento sob demanda, sem provisionar capacidade
  hash_key       = "file_id"         # Chave primária (ID dos arquivos)

  attribute {
    name = "file_id" # Atributo file_id
    type = "S"       # Tipo string
  }

  tags = {
    Name = var.register-table-api-upload-marcelo-v1
    Environment = "dev"
  }
}
