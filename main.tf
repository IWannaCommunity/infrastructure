# Cloudflare
variable "cf_apikey" {}
variable "cf_orgid" {}
variable "cf_email" {}

provider "cloudflare" {
  token  = "${var.cf_apikey}"
  org_id = "${var.cf_orgid}"
  email  = "${var.cf_email}"
}

# DigitalOcean
variable "do_apikey" {}
variable "do_spacesid" {}
variable "do_spacessecret" {}

provider "digitalocean" {
  token = "${var.do_apikey}"

  spaces_access_id  = "${var.do_spacesid}"
  spaces_secret_key = "${var.do_spacessecret}"
}
