resource "kubernetes_namespace" "starz0r" {
  metadata {
    name = "starz0r"
  }
}

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

# Quassel
variable "quassel_database_addr" {}
variable "quassel_database_pass" {}
variable "quassel_ldap_admin_pass" {}
module "quassel" {
  source = "./quassel"

  database_addr   = "${var.quassel_database_addr}"
  database_pass   = "${var.quassel_database_pass}"
  ldap_admin_pass = "${var.quassel_ldap_admin_pass}"
}

# Ejabberd
variable "ejabberd_database_addr" {}
variable "ejabberd_database_pass" {}
variable "ejabberd_ldap_pass" {}
module "ejabberd" {
  source = "./ejabberd"

  db_host   = "${var.ejabberd_database_addr}"
  db_pass   = "${var.ejabberd_database_pass}"
  ldap_pass = "${var.ejabberd_ldap_pass}"
  cf_email  = "${var.openldap_cf_email}"
  cf_apikey = "${var.openldap_cf_apikey}"
}
