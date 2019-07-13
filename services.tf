provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.freeman.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.cluster_ca_certificate)}"

  load_config_file = false
}

// starz0r's services

# quassel
resource "kubernetes_deployment" "quassel" {
  metadata {
    name = "quassel"
  }

  spec {
    template {
      metadata {}
      spec {
        container {
          image = "linuxserver/quassel-core"
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
            value = "postgresql.master.host"
          }
          env {
            name  = "DB_PGSQL_PASSWORD"
            value = "postgresql.master.postgresql_role.starz0r_quassel.password"
          }
          env {
            name  = "DB_PGSQL_PORT"
            value = "postgresql.master.port"
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
            name  = "RUN_OTPS"
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
    port {
      name        = "4242"
      port        = 4242
      target_port = 4242
    }

    type = "LoadBalancer"
  }
}
