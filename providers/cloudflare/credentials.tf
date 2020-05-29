# Cloudflare
provider "cloudflare" {
  api_token  = "${var.apikey}"
  account_id = "${var.orgid}"
  email      = "${var.email}"
}
