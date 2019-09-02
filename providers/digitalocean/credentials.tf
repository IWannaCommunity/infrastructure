provider "digitalocean" {
  token = "${var.do_apikey}"

  spaces_access_id  = "${var.do_spacesid}"
  spaces_secret_key = "${var.do_spacessecret}"
}
