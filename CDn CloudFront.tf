provider "aws" {
  region = "us-east-1"
}
resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "Example Origin Access Identity"
}
resource "aws_s3_bucket" "example" {
  bucket = "example-bucket"
  acl = "private"
  tags = {
    Name = "Example Bucket"
  }
}
resource "aws_cloudfront_distribution" "example" {
  origin {
    domain_name = aws_s3_bucket.example.bucket_regional_domain_name
    origin_id = "example-s3-bucket"
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.example.id}"
    }
  }
  enabled = true
  is_ipv6_enabled = true
  aliases = ["example.com", "www.example.com"]
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "example-s3-bucket"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }
  default_root_object = "index.html"
  price_class = "PriceClass_All"
  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    ssl_support_method = "sni-only"
  }
  tags = {
    Name = "Example CloudFront Distribution"
  }
}
