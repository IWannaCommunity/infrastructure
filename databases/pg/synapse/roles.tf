variable "synapse_pass" {}
resource "postgresql_role" "synapse" {
  name             = "synapse"
  password         = "${var.synapse_pass}"
  login            = true
  connection_limit = 10
}
