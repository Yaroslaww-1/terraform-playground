resource "aws_dynamodb_table" "db_dynamodb_table" {
  name = "db_dynamodb_table"
  billing_mode = "PROVISIONED"
  read_capacity= "1"
  write_capacity= "1"

  attribute {
    name = "requestId"
    type = "S"
  }
  hash_key = "requestId"
}