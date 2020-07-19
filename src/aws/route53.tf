# Define Route53 resources.
# https://aws.amazon.com/route53

# A hosted zone is a container that holds information about how
# you want to route traffic for a domain, such as example.com,
# and its subdomains.
# https://www.terraform.io/docs/providers/aws/r/route53_zone.html
resource "aws_route53_zone" "domain" {
  # The DNS name of this hosted zone, for instance "example.com".
  name = var.domain

  # Destroy all records in the zone when destroying the zone.
  force_destroy = true
}

# If IPv6 is enabled for CloudFront, you'll need to create two alias records for
# the distribution, one to route IPv4 traffic to the distribution, and one to
# route IPv6 traffic.

# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "A" {
  # The ID of the hosted zone to contain this record.
  zone_id = aws_route53_zone.domain.zone_id

  # The name of the record.
  name = var.domain

  # The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR,
  #   NS, PTR, SOA, SPF, SRV and TXT.
  type = "A"

  # If an alias record points to an AWS resource, you can't set
  # the time to live (TTL); it uses the default TTL for the resource.
  alias {
    # DNS domain name for a CloudFront distribution, S3 bucket, ELB,
    #   or another resource record set in this hosted zone.
    name = aws_cloudfront_distribution.cdn.domain_name

    # Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or
    #   Route 53 hosted zone.
    zone_id = aws_cloudfront_distribution.cdn.hosted_zone_id

    # Set to true if you want Route 53 to determine whether to respond
    #   to DNS queries using this resource record set by checking the health of
    #   the resource record set.
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "AAAA" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = var.domain
  type    = "AAAA"

  alias {
    name    = aws_cloudfront_distribution.cdn.domain_name
    zone_id = aws_cloudfront_distribution.cdn.hosted_zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "CNAME" {
  count = length(var.alias_domains)

  zone_id = aws_route53_zone.domain.zone_id
  name    = var.alias_domains[count.index]
  type    = "CNAME"
  records = [var.domain]
  ttl     = 86400
}

resource "aws_route53_record" "cert_validation" {
  count = length(var.alias_domains) + 1

  zone_id = aws_route53_zone.domain.zone_id
  name    = aws_acm_certificate.ssl.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.ssl.domain_validation_options[count.index].resource_record_type
  records = [aws_acm_certificate.ssl.domain_validation_options[count.index].resource_record_value]
  ttl     = 60
}
