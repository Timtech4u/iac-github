# ---------------------------------------------------------------------------------------------------------------------
# Create S3 Bucket and DynamoDB Table
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "terraform_state" {
  bucket = "github-terraform-example-terraform-state"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the IAM policies
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "terraform_s3_list_read_write_policy" {
  name        = "S3TerraformStateListReadWriteAccess"
  path        = "/"
  description = "This policy grants limited read and write permissions to the Terraform DyanmoDB state lock table."

  policy = data.aws_iam_policy_document.terraform_s3_list_read_write_policy_document.json
}

data "aws_iam_policy_document" "terraform_s3_list_read_write_policy_document" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.terraform_state_lock.arn]
  }
}

resource "aws_iam_policy" "terraform_dynamodb_read_write_policy" {
  name        = "DynamoDBTerraformStateLocksReadWriteAccess"
  path        = "/"
  description = "This policy grants limited read and write permissions to the Terraform DyanmoDB state lock table."

  policy = data.aws_iam_policy_document.terraform_dynamodb_read_write_policy_document.json
}

data "aws_iam_policy_document" "terraform_dynamodb_read_write_policy_document" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [aws_dynamodb_table.terraform_state_lock.arn]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the IAM user with attached policies
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_user" "user" {
  name = "terraform-ci"
}

resource "aws_iam_user_policy_attachment" "terraform_s3_list_read_write_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.terraform_s3_list_read_write_policy.arn
}

resource "aws_iam_user_policy_attachment" "terraform_dynamodb_read_write_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.terraform_dynamodb_read_write_policy.arn
}
