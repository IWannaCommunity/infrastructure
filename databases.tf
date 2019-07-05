// global defs

resource "digitalocean_database_cluster" "pg_master" {
  name       = "pg_master"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "sf2"
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
  superuser        = true
  connect_timeout  = 30
  expected_version = "11.0.0"
}

// starz0r local

# quassel user
variable "pg_starz0r_quassel_pass" {}

resource "postgresql_role" "starz0r_quassel" {
  provider         = "postgresql.master"
  name             = "starz0r_quassel"
  password         = "${var.pg_starz0r_quassel_pass}"
  login            = true
  connection_limit = 1
}

# quassel database
resource "postgresql_database" "starz0r_quassel" {
  provider         = "postgresql.master"
  name             = "starz0r_quassel"
  owner            = "starz0r_quassel"
  lc_collate       = "C"
  encoding         = "UTF8"
  connection_limit = 1
}
