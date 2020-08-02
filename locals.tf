# Define locals.
# https://www.terraform.io/docs/configuration/locals.html

locals {
  mime_types  = jsondecode(file("${path.module}/mime.json"))
  bucket_name = replace(var.domain, ".", "-")
}
