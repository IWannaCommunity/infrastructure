resource "kubernetes_service" "ejabberd" {
  metadata {
    name      = "ejabberd"
    namespace = "starz0r"
  }

  spec {
    selector = {
      servicegroup   = "freeman"
      infrastructure = "starz0r"
      app            = "ejabberd"
    }

    port {
      name        = "c2s-xmpp"
      port        = 30005
      node_port   = 30005
      target_port = 5222
    }

    port {
      name        = "c2s-xmpps"
      port        = 30008
      node_port   = 30008
      target_port = 5223
    }

    port {
      name        = "s2s-xmpp"
      port        = 30006
      node_port   = 30006
      target_port = 5269
    }

    port {
      name        = "s2s-xmpps"
      port        = 30009
      node_port   = 30009
      target_port = 5270
    }

    port {
      name        = "http-ejabberd"
      port        = 30007
      node_port   = 30007
      target_port = 5280
    }

    type             = "NodePort"
    session_affinity = "ClientIP"
  }
}
