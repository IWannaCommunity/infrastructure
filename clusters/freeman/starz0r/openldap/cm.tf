variable "cf_email" {}
variable "cf_apikey" {}

data "template_file" "certbot_cloudflare" {
  template = "${file("${path.module}/config/cloudflare.ini")}"

  vars = {
    cloudflare_email   = "${var.cf_email}"
    cloudflare_api_key = "${var.cf_apikey}"
  }
}

resource "kubernetes_config_map" "certbot" {
  metadata {
    name = "certbot"
  }

  data = {
    "cloudflare.ini" = "${data.template_file.certbot_cloudflare.rendered}"
  }
}
