terraform {
  backend "s3" {
    bucket = "actions-template-state"
    key    = "global/mystatefile/terraform.tfstate"
    region = "eu-west-2"
    # Uncomment the next line if you want to use DynamoDB for state locking
    # dynamodb_table = "state-lock"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare" # Correct source address for Cloudflare
      version = "~> 3.0"                # Specify the version you want
    }
    aws = {
      source  = "hashicorp/aws" # AWS provider remains as it is
      version = "~> 5.0"        # Specify the version you want
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "app_record" {
  zone_id = var.cloudflare_zone_id # Reference a variable for Zone ID
  name    = "apple"                  # This will create app.zinxvalkyria.space
  value   = aws_lb.app_lb.dns_name # Points to the ALB DNS name
  type    = "CNAME"                # Change to CNAME since you're pointing to a DNS name
  ttl     = 300                    # Time to live in seconds
  proxied = false                  # Set to true if you want Cloudflare's proxy features
}