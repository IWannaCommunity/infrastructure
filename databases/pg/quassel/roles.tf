variable "quassel_pass" {}
resource "postgresql_role" "quassel" {
  name             = "quassel"
  password         = "${var.quassel_pass}"
  login            = true
  connection_limit = 10
}
