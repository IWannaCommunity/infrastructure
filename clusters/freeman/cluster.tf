resource "digitalocean_kubernetes_cluster" "freeman" {
  name    = "us-services-freeman"
  region  = "sfo2"
  version = "1.13.10-do.2"
  tags    = ["production"]

  node_pool {
    name       = "freeman-worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.freeman.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.cluster_ca_certificate)}"

  load_config_file = false
}

# Default Namespace
variable "default_keycloak_superuser_pass" {}
variable "default_keycloak_database_addr" {}
variable "default_keycloak_database_pass" {}
module "default" {
  source = "./default"

  keycloak_superuser_pass = "${var.default_keycloak_superuser_pass}"
  keycloak_database_addr  = "${var.default_keycloak_database_addr}"
  keycloak_database_pass  = "${var.default_keycloak_database_pass}"

  providers = {
    kubernetes   = "kubernetes"
    digitalocean = "digitalocean"
  }
}

# Starz0r Namespace
variable "starz0r_openldap_admin_pass" {}
variable "starz0r_openldap_config_pass" {}
module "starz0r" {
  source = "./starz0r"

  openldap_admin_pass  = "${var.starz0r_openldap_admin_pass}"
  openldap_config_pass = "${var.starz0r_openldap_config_pass}"

  providers = {
    kubernetes = "kubernetes"
  }
}
