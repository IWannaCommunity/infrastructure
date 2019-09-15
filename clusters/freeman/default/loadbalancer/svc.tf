resource "kubernetes_service" "loadbalancer" {
  metadata {
    name = "freeman"
  }

  spec {
    selector = {
      servicegroup = "freeman"
    }

    # Default
    port {
      name        = "http-keycloak"
      port        = 1000
      target_port = 8080
    }

    port {
      name        = "https-keycloak"
      port        = 1001
      target_port = 8443
    }

    # Starz0r
    port {
      name        = "ldap-openldap"
      port        = 1002
      target_port = 389
    }

    type = "LoadBalancer"
  }
}
