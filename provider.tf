# DigitalOcean
variable "do_apikey" {}

provider "digitalocean" {
  token = "${var.do_apikey}"
}

# Cloudflare
variable "cf_apikey" {}
variable "cf_email" {}
variable "cf_orgid" {}

provider "cloudflare" {
  email  = "${var.cf_email}"
  token  = "${var.cf_apikey}"
  org_id = "${var.cf_orgid}"
}
