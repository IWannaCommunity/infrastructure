resource "postgresql_database" "synapse" {
  name             = "synapse"
  owner            = "synapse"
  lc_collate       = "C"
  encoding         = "UTF8"
  connection_limit = 20
}
