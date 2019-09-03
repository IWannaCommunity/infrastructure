resource "digitalocean_kubernetes_cluster" "freeman" {
  name    = "us-services-freeman"
  region  = "sfo2"
  version = "1.15.3-do.1"
  tags    = ["production"]

  node_pool {
    name       = "freeman-worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 2
  }
}

provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.freeman.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.cluster_ca_certificate)}"

  load_config_file = false
}

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
