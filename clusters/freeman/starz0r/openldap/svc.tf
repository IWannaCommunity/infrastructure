resource "kubernetes_service" "openldap" {
  metadata {
    name = "openldap"
  }

  spec {
    selector = {
      servicegroup   = "freeman"
      infrastructure = "starz0r"
      app            = "openldap"
    }

    port {
      name        = "ldap-openldap"
      port        = 30002
      node_port   = 30002
      target_port = 389
    }

    port {
      name        = "ldaps-openldap"
      port        = 30003
      node_port   = 30003
      target_port = 636
    }

    type             = "NodePort"
    session_affinity = "ClientIP"
  }
}
