# DigitalOcean
variable "do_apikey" {}
variable "do_spacesid" {}
variable "do_spacessecret" {}

provider "digitalocean" {
  token = "${var.do_apikey}"

  spaces_access_id  = "${var.do_spacesid}"
  spaces_secret_key = "${var.do_spacessecret}"
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
