variable "main_domain_name" {
  description = "portfolio DomainName"
  type        = string
  default     = "nekochans.org"
}

variable "github_txt_records" {
  type = list(string)

  default = [
    "780c9a5b36",
  ]
}
