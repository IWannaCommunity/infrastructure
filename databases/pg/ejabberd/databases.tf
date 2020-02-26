resource "postgresql_database" "ejabberd" {
  name             = "ejabberd"
  owner            = "jabber"
  lc_collate       = "C"
  encoding         = "UTF8"
  connection_limit = 3
}
