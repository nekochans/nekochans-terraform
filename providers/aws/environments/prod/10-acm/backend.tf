terraform {
  backend "s3" {
    bucket  = "prod-nekochans-portfolio-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-portfolio"
  }
}
