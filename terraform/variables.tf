variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "new_relic_license_key" {
  description = "New Relic license key"
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "IMAGE_TAG" {
  type    = string
  default = "latest"

}

# variable "account_id" {
#   description = "New Relic account ID"
#   type        = string
#   sensitive   = true # Mark as sensitive
<<<<<<< HEAD
# }
=======
# }
>>>>>>> f3cf305 (s3 backend)
