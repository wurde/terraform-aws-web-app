# Define input variables.
# https://www.terraform.io/docs/configuration/variables.html

variable "cloud" {
  type        = string
  description = "What cloud provider? Choose 'aws' or 'gcp'."
  default     = "aws"
}

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

variable "country_blacklist" {
  type        = list(string)
  description = "List of countries (ISO 3166-1-alpha-2 codes) to blacklist."
  default     = ["IR", "KP"]
}
