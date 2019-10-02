variable "freeman_starz0r_openldap_admin_pass" {}
variable "freeman_starz0r_openldap_config_pass" {}
variable "freeman_starz0r_openldap_cf_email" {}
variable "freeman_starz0r_openldap_cf_apikey" {}

variable "freeman_starz0r_quassel_database_addr" {}
variable "freeman_starz0r_quassel_database_pass" {}
variable "freeman_starz0r_quassel_ldap_admin_pass" {}

variable "freeman_default_keycloak_superuser_pass" {}
variable "freeman_default_keycloak_database_addr" {}
variable "freeman_default_keycloak_database_pass" {}

module "freeman" {
  source = "./freeman"

  starz0r_openldap_admin_pass  = "${var.freeman_starz0r_openldap_admin_pass}"
  starz0r_openldap_config_pass = "${var.freeman_starz0r_openldap_config_pass}"
  starz0r_openldap_cf_email    = "${var.freeman_starz0r_openldap_cf_email}"
  starz0r_openldap_cf_apikey   = "${var.freeman_starz0r_openldap_cf_apikey}"

  starz0r_quassel_database_addr   = "${var.freeman_starz0r_quassel_database_addr}"
  starz0r_quassel_database_pass   = "${var.freeman_starz0r_quassel_database_pass}"
  starz0r_quassel_ldap_admin_pass = "${var.freeman_starz0r_quassel_ldap_admin_pass}"

  default_keycloak_superuser_pass = "${var.freeman_default_keycloak_superuser_pass}"
  default_keycloak_database_addr  = "${var.freeman_default_keycloak_database_addr}"
  default_keycloak_database_pass  = "${var.freeman_default_keycloak_database_pass}"

  providers = {
    digitalocean = "digitalocean"
  }
}
