module "networking_resources_cloudflare" {
  source = "./networking/cloudflare"

  providers = {
    cloudflare = "cloudflare"
  }
}

variable "k8s_freeman_starz0r_openldap_admin_pass" {}
variable "k8s_freeman_starz0r_openldap_config_pass" {}
module "cluster_resources" {
  source = "./clusters"

  freeman_starz0r_openldap_admin_pass  = "${var.k8s_freeman_starz0r_openldap_admin_pass}"
  freeman_starz0r_openldap_config_pass = "${var.k8s_freeman_starz0r_openldap_config_pass}"

  providers = {
    digitalocean = "digitalocean"
  }
}
