variable "freeman_starz0r_openldap_admin_pass" {}
variable "freeman_starz0r_openldap_config_pass" {}

variable "freeman_default_keycloak_superuser_pass" {}
variable "freeman_default_keycloak_database_addr" {}
variable "freeman_default_keycloak_database_pass" {}

module "freeman" {
  source = "./freeman"

  starz0r_openldap_admin_pass  = "${var.freeman_starz0r_openldap_admin_pass}"
  starz0r_openldap_config_pass = "${var.freeman_starz0r_openldap_config_pass}"

  default_keycloak_superuser_pass = "${var.freeman_default_keycloak_superuser_pass}"
  default_keycloak_database_addr  = "${var.freeman_default_keycloak_database_addr}"
  default_keycloak_database_pass  = "${var.freeman_default_keycloak_database_pass}"

  providers = {
    digitalocean = "digitalocean"
  }
}
