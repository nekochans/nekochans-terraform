data "aws_route53_zone" "main" {
  name = var.main_domain_name
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.env == "prod" ? var.main_domain_name : var.sub_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

// ここから下は Next.js 版に変わった後でも残す
resource "aws_route53_record" "images" {
  name    = var.env == "prod" ? var.images_cdn_sub_domain : "${var.sub_domain_name}-${var.images_cdn_sub_domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.main.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.lgtm_images_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.lgtm_images_cdn.hosted_zone_id
  }
}
