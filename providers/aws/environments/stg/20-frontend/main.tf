module "frontend" {
  source          = "../../../../../modules/aws/frontend"
  env             = var.env
  sub_domain_name = var.sub_domain_name
  images_cdn_fqdn = "${var.sub_domain_name}-images.nekochans.org"
  us_east_1_acm   = data.terraform_remote_state.acm.outputs.us_east_1_acm
}

data "terraform_remote_state" "acm" {
  backend = "s3"

  config = {
    bucket  = "stg-nekochans-portfolio-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-portfolio"
  }
}
