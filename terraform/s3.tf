

# Define the S3 bucket
resource "aws_s3_bucket" "actions_template_state" {
  bucket = "actions-template-state" # Change this to your desired bucket name
  acl    = "private"           # Set the desired ACL

  # Enable versioning (optional)
  versioning {
    enabled = true
  }

  # Enable lifecycle rules (optional)
  lifecycle_rule {
    enabled = true

    expiration {
      days = 30 # Adjust as needed
    }
  }

  tags = {
    Name        = "Actions Template State Bucket"
    Environment = "Dev"
  }
}


# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.actions_template_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Use AES256 or "aws:kms" for KMS-managed keys
    }
  }
}

# Define the lifecycle configuration separately
resource "aws_s3_bucket_lifecycle_configuration" "actions_template_lifecycle" {
  bucket = aws_s3_bucket.actions_template_state.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    expiration {
      days = 30 # Adjust as needed
    }
  }
}