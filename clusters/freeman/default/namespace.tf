# Load Balancer
module "loadbalancer" {
  source = "./loadbalancer"
}

variable "keycloak_superuser_pass" {}
variable "keycloak_database_addr" {}
variable "keycloak_database_pass" {}
module "keycloak" {
  source = "./keycloak"

  superuser_pass = "${var.keycloak_superuser_pass}"
  database_addr  = "${var.keycloak_database_addr}"
  database_pass  = "${var.keycloak_database_pass}"
}
