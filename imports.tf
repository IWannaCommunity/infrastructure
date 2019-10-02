module "networking_resources_cloudflare" {
  source = "./networking/cloudflare"

  providers = {
    cloudflare = "cloudflare"
  }
}

variable "k8s_freeman_starz0r_openldap_admin_pass" {}
variable "k8s_freeman_starz0r_openldap_config_pass" {}
variable "k8s_freeman_default_keycloak_superuser_pass" {}
module "cluster_resources" {
  source = "./clusters"

  freeman_starz0r_openldap_admin_pass  = "${var.k8s_freeman_starz0r_openldap_admin_pass}"
  freeman_starz0r_openldap_config_pass = "${var.k8s_freeman_starz0r_openldap_config_pass}"
  freeman_starz0r_openldap_cf_email    = "${var.cf_email}"
  freeman_starz0r_openldap_cf_apikey   = "${var.cf_apikey}"

  freeman_default_keycloak_superuser_pass = "${var.k8s_freeman_default_keycloak_superuser_pass}"
  freeman_default_keycloak_database_addr  = "${local.PG_MASTER_ADDR}"
  freeman_default_keycloak_database_pass  = "${var.db_pg_keycloak_pass}"

  providers = {
    digitalocean = "digitalocean"
  }
}

variable "db_pg_keycloak_pass" {}
variable "db_pg_quassel_pass" {}
module "database_resources" {
  source = "./databases"

  db_pg_keycloak_pass = "${var.db_pg_keycloak_pass}"
  db_pg_quassel_pass  = "${var.db_pg_quassel_pass}"

  providers = {
    digitalocean = "digitalocean"
  }
}
