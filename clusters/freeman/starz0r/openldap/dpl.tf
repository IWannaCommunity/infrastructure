# openldap
variable "admin_pass" {}
variable "config_pass" {}

resource "kubernetes_deployment" "openldap" {
  metadata {
    name = "openldap"
    labels = {
      name           = "openldap"
      app            = "openldap"
      servicegroup   = "freeman"
      infrastructure = "starz0r"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app          = "openldap"
        servicegroup = "freeman"
      }
    }

    template {
      metadata {
        name = "openldap"
        labels = {
          name           = "openldap"
          app            = "openldap"
          infrastructure = "starz0r"
          servicegroup   = "freeman"
        }
      }
      spec {
        container {
          image = "osixia/openldap:release-1.3.0-dev-amd64"
          name  = "openldap"

          env {
            name  = "LDAP_ORGANISATION"
            value = "Starz0r"
          }
          env {
            name  = "LDAP_DOMAIN"
            value = "starz0r.com"
          }
          env {
            name  = "LDAP_BASE_DN"
            value = ""
          }
          env {
            name  = "LDAP_ADMIN_PASSWORD"
            value = "${var.admin_pass}"
          }
          env {
            name  = "LDAP_CONFIG_PASSWORD"
            value = "${var.config_pass}"
          }
          env {
            name  = "LDAP_READONLY_USER"
            value = false
          }
          env {
            name  = "LDAP_READONLY_USER_USERNAME"
            value = "readonly"
          }
          env {
            name  = "LDAP_READONLY_USER_PASSWORD"
            value = "readonly"
          }
          env {
            name  = "LDAP_RFC2307BIS_SCHEMA"
            value = false
          }
          env {
            name  = "LDAP_BACKEND"
            value = "mdb"
          }
          env {
            name  = "LDAP_TLS"
            value = false
          }
          env {
            name  = "LDAP_TLS_ENFORCE"
            value = false
          }
          env {
            name  = "LDAP_REPLICATION"
            value = false
          }
          env {
            name  = "KEEP_EXISTING_CONFIG"
            value = false
          }
          env {
            name  = "LDAP_REMOVE_CONFIG_AFTER_SETUP"
            value = true
          }
          env {
            name  = "LDAP_SSL_HELPER_PREFIX"
            value = "ldap"
          }
          env {
            name  = "DISABLE_CHOWN"
            value = false
          }

          port {
            container_port = 389
            protocol       = "TCP"
          }

          volume_mount {
            name       = "ldap-data"
            mount_path = "/var/lib/ldap"
          }
          volume_mount {
            name       = "ldap-config"
            mount_path = "/etc/ldap/slapd.d"
          }
          volume_mount {
            name       = "ldap-certs"
            mount_path = "/container/service/slapd/assets/certs"
          }

          liveness_probe {
            tcp_socket {
              port = 389
            }
            initial_delay_seconds = 10
            period_seconds        = 30
            success_threshold     = 1
          }
          readiness_probe {
            tcp_socket {
              port = 389
            }
            initial_delay_seconds = 15
            period_seconds        = 30
            success_threshold     = 1
          }
        }

        volume {
          name = "ldap-data"
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.openldap-data.metadata.0.name}"
          }
        }
        volume {
          name = "ldap-config"
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.openldap-config.metadata.0.name}"
          }
        }
        volume {
          name = "ldap-certs"
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.openldap-certs.metadata.0.name}"
          }
        }

      }
    }
  }
}
