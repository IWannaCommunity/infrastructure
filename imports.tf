module "networking_resources_cloudflare" {
  source = "./networking/cloudflare"

  providers = {
    cloudflare = "cloudflare"
  }
}

variable "k8s_freeman_starz0r_openldap_admin_pass" {}
variable "k8s_freeman_starz0r_openldap_config_pass" {}
variable "k8s_freeman_default_keycloak_superuser_pass" {}
variable "k8s_freeman_iwc_automod_discord_token" {}
module "cluster_resources" {
  source = "./clusters"

  freeman_starz0r_openldap_admin_pass  = "${var.k8s_freeman_starz0r_openldap_admin_pass}"
  freeman_starz0r_openldap_config_pass = "${var.k8s_freeman_starz0r_openldap_config_pass}"
  freeman_starz0r_openldap_cf_email    = "${var.cf_email}"
  freeman_starz0r_openldap_cf_apikey   = "${var.cf_apikey}"

  freeman_starz0r_quassel_database_addr   = "${local.PG_MASTER_ADDR}"
  freeman_starz0r_quassel_database_pass   = "${var.db_pg_quassel_pass}"
  freeman_starz0r_quassel_ldap_admin_pass = "${var.k8s_freeman_starz0r_openldap_admin_pass}"

  freeman_default_keycloak_superuser_pass = "${var.k8s_freeman_default_keycloak_superuser_pass}"
  freeman_default_keycloak_database_addr  = "${local.PG_MASTER_ADDR}"
  freeman_default_keycloak_database_pass  = "${var.db_pg_keycloak_pass}"

  freeman_starz0r_ejabberd_database_addr = "${local.PG_MASTER_ADDR}"
  freeman_starz0r_ejabberd_database_pass = "${var.db_pg_jabber_pass}"
  freeman_starz0r_ejabberd_ldap_pass     = "${var.k8s_freeman_starz0r_openldap_admin_pass}"

  freeman_iwc_automod_discord_token = "${var.k8s_freeman_iwc_automod_discord_token}"

  providers = {
    digitalocean = "digitalocean"
  }
}

variable "db_pg_keycloak_pass" {}
variable "db_pg_quassel_pass" {}
variable "db_pg_synapse_pass" {}
variable "db_pg_jabber_pass" {}
module "database_resources" {
  source = "./databases"

  db_pg_keycloak_pass = "${var.db_pg_keycloak_pass}"
  db_pg_quassel_pass  = "${var.db_pg_quassel_pass}"
  db_pg_synapse_pass  = "${var.db_pg_synapse_pass}"
  db_pg_jabber_pass   = "${var.db_pg_jabber_pass}"

  providers = {
    digitalocean = "digitalocean"
  }
}
