# Configure Terraform backend using an S3 bucket

terraform {
  backend "s3" {
    bucket         = "actions-template-terraform-state"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-1"
    # dynamodb_table = "state-lock" # Name of your DynamoDB table for state locking
    # encrypt        = true         # Enable encryption for the state file
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the Cloudflare provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Create a DNS record in Cloudflare
resource "cloudflare_record" "app_record" {
  zone_id = var.cloudflare_zone_id
  name    = "app"
  value   = aws_lb.app_lb.dns_name
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
