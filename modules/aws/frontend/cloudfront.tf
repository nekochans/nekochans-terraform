resource "aws_cloudfront_distribution" "lgtm_images_cdn" {
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    target_origin_id       = "S3-${aws_s3_bucket.images_bucket.bucket}"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "nekochans.org Images"

  aliases = [var.images_cdn_fqdn]

  logging_config {
    bucket          = aws_s3_bucket.images_access_logs.bucket_domain_name
    include_cookies = false
    prefix          = "raw/"
  }

  origin {
    domain_name = aws_s3_bucket.images_bucket.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.images_bucket.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.images_bucket.cloudfront_access_identity_path
    }

    custom_header {
      name  = "Accept"
      value = "image/png,image/jpeg,image/webp"
    }

    custom_header {
      name  = "Content-Type"
      value = "image/png,image/jpeg,image/webp"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.us_east_1_acm["sub_arn"]
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
}
