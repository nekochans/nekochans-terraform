output "acm" {
  value = {
    "main_arn" = data.aws_acm_certificate.main.arn
    "sub_arn"  = data.aws_acm_certificate.sub.arn
  }
}
