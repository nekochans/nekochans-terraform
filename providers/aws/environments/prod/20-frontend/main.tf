module "frontend" {
  source          = "../../../../../modules/aws/frontend"
  env             = var.env
  sub_domain_name = var.sub_domain_name
  us_east_1_acm   = data.terraform_remote_state.acm.outputs.us_east_1_acm
}

data "terraform_remote_state" "acm" {
  backend = "s3"

  config = {
    bucket  = "prod-nekochans-portfolio-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-portfolio"
  }
}
