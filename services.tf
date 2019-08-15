provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.freeman.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.freeman.kube_config.0.cluster_ca_certificate)}"

  load_config_file = false
}

// services for all

# freeman loadbalancer
resource "kubernetes_service" "freeman-loadbalancer" {
  metadata {
    name = "freeman"
  }

  spec {
    selector = {
      servicegroup = "freeman"
    }
    port {
      name        = "rawtcp"
      port        = 4242
      target_port = 4242
    }
    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

# keycloak
variable "keycloak_superuser_pass" {}

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
          env {
            name  = "KEYCLOAK_HOSTNAME"
            value = "ident.iwannacommunity.com"
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

// starz0r's services

# quassel
resource "kubernetes_deployment" "quassel" {
  metadata {
    name = "quassel"
    labels = {
      infrastructure = "starz0r"
      servicegroup   = "freeman"
    }
  }

  spec {

    selector {
      match_labels = {
        infrastructure = "starz0r"
        servicegroup   = "freeman"
      }
    }

    template {
      metadata {
        labels = {
          infrastructure = "starz0r"
          servicegroup   = "freeman"
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
