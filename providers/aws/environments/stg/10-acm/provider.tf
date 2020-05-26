provider "aws" {
  region  = "ap-northeast-1"
  profile = "nekochans-portfolio"
}

provider "aws" {
  region  = "us-east-1"
  profile = "nekochans-portfolio"
  alias   = "us-east-1"
}
