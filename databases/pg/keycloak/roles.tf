variable "keycloak_pass" {}
resource "postgresql_role" "keycloak" {
  name             = "keycloak"
  password         = "${var.keycloak_pass}"
  login            = true
  connection_limit = 10
}
