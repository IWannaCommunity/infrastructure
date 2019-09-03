# freeman loadbalancer
resource "kubernetes_service" "loadbalancer" {
  metadata {
    name = "freeman"
  }

  spec {
    selector = {
      servicegroup = "freeman"
    }
    session_affinity = "ClientIP"
    port {
      name        = "ldap-openldap"
      port        = 1002
      target_port = 389
    }

    type = "LoadBalancer"
  }
}
