resource "aws_dynamodb_table" "db_dynamodb_table" {
  name = "db_dynamodb_table"
  billing_mode = "PROVISIONED"
  read_capacity= "1"
  write_capacity= "1"

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "requestId"
    type = "S"
  }
  hash_key = "requestId"
}