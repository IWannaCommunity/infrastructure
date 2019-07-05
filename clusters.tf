resource "digitalocean_kubernetes_cluster" "freeman" {
  name    = "us-services-freeman"
  region  = "sf2"
  version = "1.14.1-do.4"
  tags    = ["production"]

  node_pool {
    name       = "freeman-worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}
