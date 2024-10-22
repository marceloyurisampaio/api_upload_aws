resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.upload_bucket.id}/*"
        ]
      },
      {
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ],
        "Effect": "Allow",
        "Resource": [
          register-table-api-upload-marcelo-v1.files_table.arn
        ]
      }
    ]
  })
}
