resource "digitalocean_database_cluster" "pg_master" {
  name       = "pg-master"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "sfo2"
  node_count = 1
}
