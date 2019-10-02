resource "postgresql_database" "quassel" {
  name             = "quassel"
  owner            = "quassel"
  lc_collate       = "C"
  encoding         = "UTF8"
  connection_limit = 10
}
