provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.freeman.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.cluster_ca_certificate)}"

  load_config_file = false
}

// services for all

# keycloak
variable "keycloak_superuser_pass" {}

resource "kubernetes_deployment" "keycloak" {
  metadata {
    name = "keycloak"
    labels = {
      name           = "keycloak"
      infrastructure = "all"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        infrastructure = "all"
      }
    }

    template {
      metadata {
        name = "keycloak"
        labels = {
          infrastructure = "all"
        }
      }
      spec {
        container {
          image = "jboss/keycloak:6.0.1"
          name  = "keycloak"

          env {
            name  = "DB_ADDR"
            value = "${digitalocean_database_cluster.pg_master.host}"
          }
          env {
            name  = "DB_VENDOR"
            value = "postgres"
          }
          env {
            name  = "DB_DATABASE"
            value = "${postgresql_database.keycloak.name}"
          }
          env {
            name  = "DB_USER"
            value = "${postgresql_role.keycloak.name}"
          }
          env {
            name  = "DB_PASSWORD"
            value = "${postgresql_role.keycloak.password}"
          }
          env {
            name  = "DB_PORT"
            value = "${digitalocean_database_cluster.pg_master.port}"
          }
          env {
            name  = "KEYCLOAK_USER"
            value = "Starz0r"
          }
          env {
            name  = "KEYCLOAK_PASSWORD"
            value = "${var.keycloak_superuser_pass}"
          }
          env {
            name  = "PROXY_ADDRESS_FORWARDING"
            value = "true"
          }

          port {
            container_port = 8080
            protocol       = "TCP"
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "keycloak" {
  metadata {
    name = "keycloak"
  }

  spec {
    selector = {
      infrastructure = "${kubernetes_deployment.keycloak.metadata.0.labels.infrastructure}"
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "keycloak" {
  metadata {
    name = "keycloak"

    annotations = {
      "kubernetes.io/tls-acme"            = "true"
      "kubernetes.io/ingress.class"       = "nginx"
      "certmanager.k8s.io/cluster-issuer" = "letsencrypt-prod"
    }
  }

  spec {
    rule {
      host = "ident.iwannacommunity.com"
      http {
        path {
          path = "/"
          backend {
            service_name = "keycloak"
            service_port = 8080
          }
        }
        path {
          path = "/auth"
          backend {
            service_name = "keycloak"
            service_port = 8080
          }
        }
      }
    }

    tls {
      secret_name = "tls-keycloak-cert"

      hosts = ["ident.iwannacommunity.com"]
    }
  }
}

// starz0r's services

# quassel
resource "kubernetes_deployment" "quassel" {
  metadata {
    name = "quassel"
    labels = {
      infrastructure = "starz0r"
    }
  }

  spec {

    selector {
      match_labels = {
        infrastructure = "starz0r"
      }
    }

    template {
      metadata {
        labels = {
          infrastructure = "starz0r"
        }
      }
      spec {
        container {
          image = "linuxserver/quassel-core:amd64-0.13.1-ls20"
          name  = "quassel"

          env {
            name  = "AUTH_AUTHENTICATOR"
            value = "Database"
          }
          env {
            name  = "DB_BACKEND"
            value = "PostgreSQL"
          }
          env {
            name  = "DB_PGSQL_HOSTNAME"
            value = "${digitalocean_database_cluster.pg_master.host}"
          }
          env {
            name  = "DB_PGSQL_USERNAME"
            value = "${postgresql_role.starz0r_quassel.name}"
          }
          env {
            name  = "DB_PGSQL_PASSWORD"
            value = "${postgresql_role.starz0r_quassel.password}"
          }
          env {
            name  = "DB_PGSQL_PORT"
            value = "${digitalocean_database_cluster.pg_master.port}"
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
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "quassel" {
  metadata {
    name = "quassel"
  }

  spec {
    selector = {
      infrastructure = "${kubernetes_deployment.quassel.metadata.0.labels.infrastructure}"
    }
    port {
      name        = "4242"
      port        = 4242
      target_port = 4242
    }

    type = "LoadBalancer"
  }
}
