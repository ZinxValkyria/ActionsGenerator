# Create an S3 bucket for storing Terraform state
# resource "aws_s3_bucket" "actions_template_state" {
#   bucket = "actions-template-state"
#   tags = {
#     Name = "Github Actions Template State Bucket"
#   }
# }

# Enable server-side encryption for the S3 bucket
# resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
#   bucket = aws_s3_bucket.actions_template_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# Add a lifecycle configuration to manage object expiration in the S3 bucket
# resource "aws_s3_bucket_lifecycle_configuration" "actions_template_lifecycle" {
#   bucket = aws_s3_bucket.actions_template_state.id

#   rule {
#     id     = "expire-objects"
#     status = "Enabled"

#     expiration {
#       days = 30 # Adjust as needed
#     }
#   }
# }

# Enable versioning for the S3 bucket
# resource "aws_s3_bucket_versioning" "actions_template_versioning" {
#   bucket = aws_s3_bucket.actions_template_state.id
# }
