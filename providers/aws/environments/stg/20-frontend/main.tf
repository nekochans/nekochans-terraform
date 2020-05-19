module "frontend" {
  source          = "../../../../../modules/aws/frontend"
  env             = var.env
  sub_domain_name = var.sub_domain_name
  acm             = data.terraform_remote_state.acm.outputs.acm
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
