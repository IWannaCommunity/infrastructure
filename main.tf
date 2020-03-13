# Terraform
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "iwannacommunity"

    workspaces {
      name = "prod"
    }
  }
}

# Cloudflare
variable "cf_apikey" {}
variable "cf_orgid" {}
variable "cf_email" {}

provider "cloudflare" {
  version = "~> 2.4.1"

  api_key    = "${var.cf_apikey}"
  account_id = "${var.cf_orgid}"
  email      = "${var.cf_email}"
}

# DigitalOcean
variable "do_apikey" {}
variable "do_spacesid" {}
variable "do_spacessecret" {}

provider "digitalocean" {
  version = "~> 1.14.0"
  token   = "${var.do_apikey}"

  spaces_access_id  = "${var.do_spacesid}"
  spaces_secret_key = "${var.do_spacessecret}"
}
