data "aws_route53_zone" "main" {
  name = var.main_domain_name
}

resource "aws_route53_record" "github_text" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "_github-challenge-nekochans"
  type    = "TXT"
  records = var.github_txt_records
  ttl     = "900"
}
