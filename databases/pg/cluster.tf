resource "digitalocean_database_cluster" "pg_master" {
  name       = "pg-master"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "sfo2"
  node_count = 1
}

provider "postgresql" {
  alias            = "master"
  host             = "${digitalocean_database_cluster.pg_master.host}"
  port             = "${digitalocean_database_cluster.pg_master.port}"
  database         = "${digitalocean_database_cluster.pg_master.database}"
  username         = "${digitalocean_database_cluster.pg_master.user}"
  password         = "${digitalocean_database_cluster.pg_master.password}"
  sslmode          = "require"
  superuser        = false
  connect_timeout  = 30
  expected_version = "11.0.0"
}

variable "pg_keycloak_pass" {}
module "keycloak" {
  source = "./keycloak"

  keycloak_pass = "${var.pg_keycloak_pass}"

  providers = {
    postgresql = "postgresql.master"
  }
}
