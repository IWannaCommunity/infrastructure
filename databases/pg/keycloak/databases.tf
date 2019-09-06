resource "postgresql_database" "keycloak" {
  name             = "keycloak"
  owner            = "keycloak"
  lc_collate       = "C"
  encoding         = "UTF8"
  connection_limit = 10
}
