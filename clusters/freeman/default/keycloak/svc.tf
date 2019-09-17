resource "kubernetes_service" "keycloak" {
  metadata {
    name = "keycloak"
  }

  spec {
    selector = {
      servicegroup   = "freeman"
      infrastructure = "all"
      app            = "keycloak"
    }

    port {
      name        = "http-keycloak"
      port        = 30000
      node_port   = 30000
      target_port = 8080
    }

    port {
      name        = "https-keycloak"
      port        = 30001
      node_port   = 30001
      target_port = 8443
    }

    type             = "NodePort"
    session_affinity = "ClientIP"
  }
}
