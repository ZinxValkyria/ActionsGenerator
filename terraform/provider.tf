terraform {
  backend "s3" {
    bucket         = "actions-template-state"
    # dynamodb_table = "state-lock"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-2"
  }
}

# resource "aws_dynamodb_table" "terraform_state_lock" {
#   name           = "state-lock"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "Terraform State Lock Table"
#   }
# }
