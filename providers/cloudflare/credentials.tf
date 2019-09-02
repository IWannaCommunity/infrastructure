# Cloudflare
provider "cloudflare" {
  token  = "${var.apikey}"
  org_id = "${var.orgid}"
  email  = "${var.email}"
}
