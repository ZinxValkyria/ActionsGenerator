

resource "aws_s3_bucket" "actions_template_state" {
  bucket = "actions-template-state"
  tags = {
    Name = " Github Actions Template State Bucket"
  }


}



resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.actions_template_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" 
    }
  }
}


      sse_algorithm = "AES256" 
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "actions_template_lifecycle" {
  bucket = aws_s3_bucket.actions_template_state.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}


# resource "aws_s3_bucket_versioning" "actions_template_versioning" {
#   bucket = aws_s3_bucket.actions_template_state.id
# }
#       days = 30 # Adjust as needed
#     }
#   }
# }
# >>>>>>> dev
