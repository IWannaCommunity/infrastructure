variable "database_addr" {}
variable "database_pass" {}
variable "ldap_admin_pass" {}

resource "kubernetes_deployment" "quassel" {
  metadata {
    name = "quassel"
    labels = {
      infrastructure = "starz0r"
      servicegroup   = "freeman"
      app            = "quassel"
    }
  }

  spec {

    selector {
      match_labels = {
        infrastructure = "starz0r"
        servicegroup   = "freeman"
        app            = "quassel"
      }
    }

    template {
      metadata {
        labels = {
          infrastructure = "starz0r"
          servicegroup   = "freeman"
          app            = "quassel"
        }
      }
      spec {
        restart_policy = "Always"
        container {
          image = "linuxserver/quassel-core:amd64-0.13.1-ls30"
          name  = "quassel"

          env {
            name  = "AUTH_AUTHENTICATOR"
            value = "LDAP"
          }
          env {
            name  = "DB_BACKEND"
            value = "PostgreSQL"
          }
          env {
            name  = "DB_PGSQL_HOSTNAME"
            value = "${var.database_addr}"
          }
          env {
            name  = "DB_PGSQL_USERNAME"
            value = "quassel"
          }
          env {
            name  = "DB_PGSQL_PASSWORD"
            value = "${var.database_pass}"
          }
          env {
            name  = "DB_PGSQL_PORT"
            value = 25060
          }
          env {
            name  = "AUTH_LDAP_HOSTNAME"
            value = "ldaps://ldaps.starz0r.com"
          }
          env {
            name  = "AUTH_LDAP_PORT"
            value = 30003
          }
          env {
            name  = "AUTH_LDAP_BIND_DN"
            value = "cn=Admin,dc=starz0r,dc=com"
          }
          env {
            name  = "AUTH_LDAP_BIND_PASSWORD"
            value = "${var.ldap_admin_pass}"
          }
          env {
            name  = "AUTH_LDAP_UID_ATTRIBUTE"
            value = "uid"
          }
          env {
            name  = "AUTH_LDAP_BASE_DN"
            value = "ou=users,dc=starz0r,dc=com"
          }
          env {
            name  = "PGID"
            value = "1000"
          }
          env {
            name  = "PUID"
            value = "1000"
          }
          env {
            name  = "RUN_OPTS"
            value = "--config-from-environment"
          }
          env {
            name  = "TZ"
            value = "America/Chicago"
          }

          port {
            container_port = 4242
            protocol       = "TCP"
          }

        }
      }
    }
  }
}
