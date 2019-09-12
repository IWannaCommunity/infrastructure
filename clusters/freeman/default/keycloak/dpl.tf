variable "superuser_pass" {}
variable "database_addr" {}
variable "database_pass" {}

resource "kubernetes_deployment" "keycloak" {
  metadata {
    name = "keycloak"
    labels = {
      name           = "keycloak"
      app            = "keycloak"
      servicegroup   = "freeman"
      infrastructure = "all"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app          = "keycloak"
        servicegroup = "freeman"
      }
    }

    template {
      metadata {
        name = "keycloak"
        labels = {
          name           = "keycloak"
          app            = "keycloak"
          infrastructure = "all"
          servicegroup   = "freeman"
        }
      }
      spec {
        container {
          image = "jboss/keycloak:7.0.0"
          name  = "keycloak"

          resources {
            requests {
              cpu    = "200m"
              memory = "512Mi"
            }
            limits {
              cpu    = 1
              memory = "1024Mi"
            }

          }

          env {
            name  = "DB_ADDR"
            value = var.database_addr
          }
          env {
            name  = "DB_VENDOR"
            value = "postgres"
          }
          env {
            name  = "DB_DATABASE"
            value = "keycloak"
          }
          env {
            name  = "DB_USER"
            value = "keycloak"
          }
          env {
            name  = "DB_PASSWORD"
            value = var.database_pass
          }
          env {
            name  = "DB_PORT"
            value = 25060
          }
          env {
            name  = "KEYCLOAK_USER"
            value = "Starz0r"
          }
          env {
            name  = "KEYCLOAK_PASSWORD"
            value = var.superuser_pass
          }
          env {
            name  = "PROXY_ADDRESS_FORWARDING"
            value = "true"
          }
          env {
            name  = "KEYCLOAK_HOSTNAME"
            value = "ident.iwannacommunity.com"
          }
          env {
            name  = "KEYCLOAK_LOGLEVEL"
            value = "ERROR"
          }

          port {
            container_port = 8080
            protocol       = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/auth"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 3
            success_threshold     = 1
          }

        }
      }
    }
  }
}
