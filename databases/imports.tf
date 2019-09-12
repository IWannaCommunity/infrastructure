variable "db_pg_keycloak_pass" {}
module "pg" {
  source = "./pg"

  pg_keycloak_pass = "${var.db_pg_keycloak_pass}"
}

output "pg_addr" {
  value = "${module.pg.addr}"
}
