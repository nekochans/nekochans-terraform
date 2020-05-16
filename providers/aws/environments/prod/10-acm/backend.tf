terraform {
  backend "s3" {
    bucket  = "prod-nekochans-portfolio"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
