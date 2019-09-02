# Cloudflare
variable "cf_apikey" {}
variable "cf_orgid" {}
variable "cf_email" {}

provider "cloudflare" {
  token  = "${var.cf_apikey}"
  org_id = "${var.cf_orgid}"
  email  = "${var.cf_email}"
}
