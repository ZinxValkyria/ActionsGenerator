# Configure Terraform backend using an S3 bucket

terraform {
  backend "s3" {
    bucket = "actions-template-state"
    key    = "global/mystatefile/terraform.tfstate"
    region = "eu-west-2"
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
  ttl     = 300
  proxied = false
}
