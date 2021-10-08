// TODO 何故か東京リージョンの証明書が取得出来ないので別途調査
provider "aws" {
  region  = "us-east-1"
  profile = "nekochans-portfolio"
}

provider "aws" {
  region  = "us-east-1"
  profile = "nekochans-portfolio"
  alias   = "us-east-1"
}
