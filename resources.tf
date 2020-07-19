# Configure resources.

module "aws" {
  source = "./src/aws"

  dist_dir          = var.dist_dir
  domain            = var.domain
  alias_domains     = var.alias_domains
  default_ttl       = var.default_ttl
  country_blacklist = var.country_blacklist
}
