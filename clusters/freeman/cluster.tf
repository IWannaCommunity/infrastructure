resource "digitalocean_kubernetes_cluster" "freeman" {
  name    = "us-services-freeman"
  region  = "sfo2"
  version = "1.14.6-do.2"
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

provider "helm" {
  kubernetes {
    host = "${digitalocean_kubernetes_cluster.freeman.endpoint}"

    client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.cluster_ca_certificate)}"

    load_config_file = false
  }

  service_account                 = "terraform-tiller" #${module.default.module.tiller.kubernetes_service_account.tiller.metadata.0.name}
  namespace                       = "kube-system"      #${module.default.module.tiller.kubernetes_service_account.tiller.metadata.0.namespace}
  tiller_image                    = "gcr.io/kubernetes-helm/tiller:v2.14.3"
  automount_service_account_token = true
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
    helm         = "helm"
  }
}

# Starz0r Namespace
variable "starz0r_openldap_admin_pass" {}
variable "starz0r_openldap_config_pass" {}
variable "starz0r_openldap_cf_email" {}
variable "starz0r_openldap_cf_apikey" {}
variable "starz0r_quassel_database_addr" {}
variable "starz0r_quassel_database_pass" {}
variable "starz0r_quassel_ldap_admin_pass" {}
variable "starz0r_ejabberd_database_addr" {}
variable "starz0r_ejabberd_database_pass" {}
variable "starz0r_ejabberd_ldap_pass" {}
module "starz0r" {
  source = "./starz0r"

  openldap_admin_pass  = "${var.starz0r_openldap_admin_pass}"
  openldap_config_pass = "${var.starz0r_openldap_config_pass}"
  openldap_cf_email    = "${var.starz0r_openldap_cf_email}"
  openldap_cf_apikey   = "${var.starz0r_openldap_cf_apikey}"

  quassel_database_addr   = "${var.starz0r_quassel_database_addr}"
  quassel_database_pass   = "${var.starz0r_quassel_database_pass}"
  quassel_ldap_admin_pass = "${var.starz0r_quassel_ldap_admin_pass}"

  ejabberd_database_addr = "${var.starz0r_ejabberd_database_addr}"
  ejabberd_database_pass = "${var.starz0r_ejabberd_database_pass}"
  ejabberd_ldap_pass     = "${var.starz0r_ejabberd_ldap_pass}"

  providers = {
    kubernetes = "kubernetes"
  }
}
