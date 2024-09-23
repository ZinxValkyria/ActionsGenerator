variable "cloudflare_api_token" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true  # Mark as sensitive
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true  # Mark as sensitive
}
