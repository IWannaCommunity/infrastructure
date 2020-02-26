# ejabberd
resource "kubernetes_deployment" "ejabberd" {
  metadata {
    name = "ejabberd"
    labels = {
      name           = "ejabberd"
      app            = "ejabberd"
      servicegroup   = "freeman"
      infrastructure = "starz0r"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app          = "ejabberd"
        servicegroup = "freeman"
      }
    }

    template {
      metadata {
        name = "ejabberd"
        labels = {
          name           = "ejabberd"
          app            = "ejabberd"
          infrastructure = "starz0r"
          servicegroup   = "freeman"
        }
      }
      spec {
        container {
          security_context {
            run_as_user = 0
          }
          image = "ejabberd/ecs@sha256:cf15b34db7afb3162e42a7573a11b306bf469a4faca0a0427b7b876dc37fd508" // 19.09.1
          name  = "ejabberd"

          volume_mount {
            name       = "config"
            mount_path = "/home/ejabberd/conf/ejabberd.yml"
            sub_path   = "ejabberd.yml"
          }
          volume_mount {
            name       = "ejabberd-certs"
            mount_path = "/home/ejabberd/acme"
          }

          port {
            name           = "ejabberd-c2s"
            container_port = 5222
            protocol       = "TCP"
          }
          port {
            name           = "ejabberd-c2stls"
            container_port = 5223
            protocol       = "TCP"
          }
          port {
            name           = "ejabberd-s2s"
            container_port = 5269
            protocol       = "TCP"
          }
          port {
            name           = "ejabberd-s2stls"
            container_port = 5270
            protocol       = "TCP"
          }
          port {
            name           = "ejabberd-http"
            container_port = 5280
            protocol       = "TCP"
          }

          liveness_probe {
            tcp_socket {
              port = 5222
            }
            initial_delay_seconds = 30
            period_seconds        = 30
            success_threshold     = 1
          }
          readiness_probe {
            tcp_socket {
              port = 5222
            }
            initial_delay_seconds = 30
            period_seconds        = 30
            success_threshold     = 1
          }
        }

        volume {
          name = "config"
          config_map {
            name = "ejabberd"
          }
        }
        volume {
          name = "ejabberd-certs"
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.ejabberd-certs.metadata.0.name}"
          }
        }

      }
    }
  }
}
