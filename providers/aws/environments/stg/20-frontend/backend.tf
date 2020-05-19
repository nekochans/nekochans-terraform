terraform {
  backend "s3" {
    bucket  = "stg-nekochans-portfolio-tfstate"
    key     = "frontend/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "nekochans-portfolio"
  }
}
