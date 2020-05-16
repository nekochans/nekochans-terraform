terraform {
  backend "s3" {
    bucket  = "stg-nekochans-portfolio"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-dev"
  }
}
