variable "env" {
  description = "The target environment"
  type        = string
  default     = ""
}

variable "frontend_s3_bucket_name" {
  description = "https://github.com/nekochans/portfolio-frontend Hosting S3Bucket"
  type        = string
  default     = "nekochans-portfolio-frontend"
}

variable "frontend_access_logs_s3_bucket_name" {
  description = "https://github.com/nekochans/portfolio-frontend AccessLog S3Bucket"
  type        = string
  default     = "nekochans-portfolio-frontend-logs"
}

variable "main_domain_name" {
  description = "portfolio DomainName"
  type        = string
  default     = "nekochans.org"
}

variable "sub_domain_name" {
  description = "portfolio DomainName"
  type        = string
  default     = ""
}

variable "us_east_1_acm" {
  type = map(string)

  default = {}
}

variable "test" {
  type = map(string)

  default = "abc"
}
