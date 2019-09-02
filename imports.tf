variable "cf_apikey" {}
variable "cf_orgid" {}
variable "cf_email" {}

module "cloudflare" {
  source = "./providers/cloudflare"

  apikey = "${var.cf_apikey}"
  orgid  = "${var.cf_orgid}"
  email  = "${var.cf_email}"
}
