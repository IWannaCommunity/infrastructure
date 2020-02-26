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

output "addr" {
  value = "${digitalocean_database_cluster.pg_master.host}"
}

variable "pg_keycloak_pass" {}
module "keycloak" {
  source = "./keycloak"

  keycloak_pass = "${var.pg_keycloak_pass}"

  providers = {
    postgresql = "postgresql.master"
  }
}

variable "pg_quassel_pass" {}
module "quassel" {
  source = "./quassel"

  quassel_pass = "${var.pg_quassel_pass}"

  providers = {
    postgresql = "postgresql.master"
  }
}

variable "pg_synapse_pass" {}
module "synapse" {
  source = "./synapse"

  synapse_pass = "${var.pg_synapse_pass}"

  providers = {
    postgresql = "postgresql.master"
  }
}

variable "pg_jabber_pass" {}
module "ejabberd" {
  source = "./ejabberd"

  jabber_pass = "${var.pg_jabber_pass}"

  providers = {
    postgresql = "postgresql.master"
  }
}
