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

// ここから下は Next.js 版に変わった後でも残す
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
