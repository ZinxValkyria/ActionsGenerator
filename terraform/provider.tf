# Configure Terraform backend using an S3 bucket
terraform {
  backend "s3" {
    bucket = "actions-template-state" # Name of the S3 bucket to store the state file
    key    = "global/mystatefile/terraform.tfstate" # Path to the state file within the bucket
    region = "eu-te-2" # AWS region for the S3 bucket

    # Uncomment the next line if you want to use DynamoDB for state locking
    # dynamodb_table = "state-lock"
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
  zone_id = var.cloudflare_zone_id       #
  name    = "app"                     # DNS record name
  value   = aws_lb.app_lb.dns_name       # Value of the DNS record
  type    = "CNAME"                     # Type of the DNS record
  ttl     = 300                          # Time-to-live for the DNS record, in seconds
  proxied = false                        # Set to true to enable Cloudflare's proxying features
}
