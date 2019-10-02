#resource "kubernetes_namespace" "starz0r" {
#  metadata {
#    name = "starz0r"
#  }
#}

# OpenLDAP
variable "openldap_admin_pass" {}
variable "openldap_config_pass" {}
variable "openldap_cf_email" {}
variable "openldap_cf_apikey" {}
module "openldap" {
  source = "./openldap"

  admin_pass  = "${var.openldap_admin_pass}"
  config_pass = "${var.openldap_config_pass}"
  cf_email    = "${var.openldap_cf_email}"
  cf_apikey   = "${var.openldap_cf_apikey}"
}
}
