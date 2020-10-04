variable "dist_dir" {
  type        = string
  description = "The distribution directory to serve via static asset host."
}

variable "domain" {
  type        = string
  description = "The primary domain name."
}

variable "alias_domains" {
  type        = list(string)
  description = "The other alias domain names (www.example.com)."
  default     = []
}

variable "default_ttl" {
  type        = number
  description = "The default TTL in seconds (default is 1 day)."
  default     = 86400
}

variable "price_class" {
  type        = string
  description = "Control CloudFront costs (default is PriceClass_All)."
  default     = "PriceClass_All"
}

variable "country_blacklist" {
  type        = list(string)
  description = "List of countries (ISO 3166-1-alpha-2 codes) to blacklist."
  default     = ["IR", "KP"]
}
