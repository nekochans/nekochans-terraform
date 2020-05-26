resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = aws_s3_bucket.frontend.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.frontend.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend_origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = var.env == "prod" ? [var.main_domain_name] : ["${var.sub_domain_name}.${var.main_domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.frontend.bucket}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "https-only"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  price_class = "PriceClass_200"

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 404
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.env == "prod" ? var.us_east_1_acm["main_arn"] : var.us_east_1_acm["sub_arn"]
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2018"
  }

  logging_config {
    include_cookies = true
    bucket          = aws_s3_bucket.frontend_access_logs.bucket_domain_name
    prefix          = "raw/"
  }
}
