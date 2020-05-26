module "ap_northeast_1_acm" {
  source = "../../../../../modules/aws/acm"
}

module "us_east_1_acm" {
  source = "../../../../../modules/aws/acm"

  providers = {
    aws = aws.us-east-1
  }
}
