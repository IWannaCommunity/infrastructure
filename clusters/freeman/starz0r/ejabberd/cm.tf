variable "db_host" {}
variable "db_pass" {}
variable "ldap_pass" {}
variable "cf_email" {}
variable "cf_apikey" {}

data "template_file" "ejabberd" {
  template = "${file("${path.module}/config/ejabberd.yml")}"

  vars = {
    database_host = "${var.db_host}"
    database_pass = "${var.db_pass}"
    ldap_pass     = "${var.ldap_pass}"
  }
}

resource "kubernetes_config_map" "ejabberd" {
  metadata {
    name = "ejabberd"
  }

  data = {
    "ejabberd.yml" = "${data.template_file.ejabberd.rendered}"
  }
}

data "template_file" "certbot_cloudflare" {
  template = "${file("${path.module}/config/cloudflare.ini")}"

  vars = {
    cloudflare_email   = "${var.cf_email}"
    cloudflare_api_key = "${var.cf_apikey}"
  }
}

resource "kubernetes_config_map" "certbot" {
  metadata {
    name = "certbot-ejabberd"
  }

  data = {
    "cloudflare.ini" = "${data.template_file.certbot_cloudflare.rendered}"
  }
}
