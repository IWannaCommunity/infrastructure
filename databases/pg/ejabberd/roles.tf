variable "jabber_pass" {}
resource "postgresql_role" "jabber" {
  name             = "jabber"
  password         = "${var.jabber_pass}"
  login            = true
  connection_limit = 3
}
