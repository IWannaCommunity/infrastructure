variable "db_pg_keycloak_pass" {}
variable "db_pg_quassel_pass" {}
variable "db_pg_synapse_pass" {}
variable "db_pg_jabber_pass" {}
module "pg" {
  source = "./pg"

  pg_keycloak_pass = "${var.db_pg_keycloak_pass}"
  pg_quassel_pass  = "${var.db_pg_quassel_pass}"
  pg_synapse_pass  = "${var.db_pg_synapse_pass}"
  pg_jabber_pass   = "${var.db_pg_jabber_pass}"
}

output "pg_addr" {
  value = "${module.pg.addr}"
}
