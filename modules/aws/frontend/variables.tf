variable "env" {
  description = "The target environment"
  type        = string
  default     = ""
}

variable "images_s3_bucket_name" {
  description = "https://github.com/nekochans/portfolio-frontend Images S3Bucket"
  type        = string
  default     = "nekochans-portfolio-images"
}

variable "images_access_logs_s3_bucket_name" {
  description = "https://github.com/nekochans/portfolio-frontend Images AccessLog S3Bucket"
  type        = string
  default     = "nekochans-portfolio-images-logs"
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

variable "images_cdn_fqdn" {
  description = "portfolio images CDN FQDN"
  type        = string
  default     = ""
}

variable "images_cdn_sub_domain" {
  description = "portfolio images CDN DomainName"
  type        = string
  default     = "images"
}

variable "us_east_1_acm" {
  type = map(string)

  default = {}
}
