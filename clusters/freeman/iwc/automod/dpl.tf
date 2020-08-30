variable "discord_token" {}

resource "kubernetes_deployment" "automod" {
  metadata {
    name      = "automod"
    namespace = "iwc"
    labels = {
      infrastructure = "iwc"
      servicegroup   = "freeman"
      app            = "automod"
    }
  }

  spec {

    selector {
      match_labels = {
        infrastructure = "iwc"
        servicegroup   = "freeman"
        app            = "automod"
      }
    }

    template {
      metadata {
        labels = {
          infrastructure = "iwc"
          servicegroup   = "freeman"
          app            = "automod"
        }
      }
      spec {
        restart_policy = "Always"
        container {
          image = "registry.digitalocean.com/public-code/automod@sha256:22ace01bf2562556ba24761467a7ffa150474cc87b7238b07594e0a62a2ad627" // 0.1.0
          name  = "automod"

          env {
            name  = "DISCORD_TOKEN"
            value = var.discord_token
          }

        }
        image_pull_secrets {
          name = "registry-public-code"
        }
      }
    }
  }
}
