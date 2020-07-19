# Define S3 resources.
# https://aws.amazon.com/s3

# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
resource "aws_s3_bucket" "domain" {
  # The name of the bucket.
  bucket = local.bucket_name

  # The canned ACL to apply. Defaults to "private".
  #   https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
  acl = "public-read"

  # Configure your bucket as a static website. It'll be available
  #   at the AWS Region-specific website endpoint of the bucket.
  #   http://bucket-name.s3-website-Region.amazonaws.com
  website {
    index_document = "index.html"
  }

  # Enable versioning. Once you version-enable a bucket, it can never
  #   return to an unversioned state. You can, however, suspend versioning
  #   on that bucket.
  versioning {
    enabled = true
  }

  # Define how Amazon S3 manages objects during their lifetime.
  lifecycle_rule {
    # Object key prefix identifying one or more objects to apply the rule.
    prefix = "/"

    # Enable this lifecycle rule.
    enabled = true

    noncurrent_version_transition {
      # Specify the number of days after object creation
      #   when the specific rule action takes effect.
      days = 30

      # Specifies the Amazon S3 storage class.
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  # All objects (including locked) are deleted when deleting a bucket.
  force_destroy = true
}

resource "aws_s3_bucket_policy" "domain_policy" {
  bucket = aws_s3_bucket.domain.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_object" "dist" {
  for_each = fileset(var.dist_dir, "**")

  acl    = "public-read"
  bucket = aws_s3_bucket.domain.id
  key    = each.value
  source = "${var.dist_dir}/${each.value}"
  etag   = filemd5("${var.dist_dir}/${each.value}")

  content_type = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}
