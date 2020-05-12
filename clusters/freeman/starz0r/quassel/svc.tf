resource "kubernetes_service" "quassel" {
  metadata {
    name      = "quassel"
    namespace = "starz0r"
  }

  spec {
    selector = {
      servicegroup   = "freeman"
      infrastructure = "starz0r"
      app            = "quassel"
    }

    port {
      name        = "rawtcp-quassel"
      port        = 30004
      node_port   = 30004
      target_port = 4242
    }

    type             = "NodePort"
    session_affinity = "ClientIP"
  }
}
