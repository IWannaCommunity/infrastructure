resource "kubernetes_persistent_volume_claim" "ejabberd-certs" {
  metadata {
    name      = "ejabberd-certs"
    namespace = "starz0r"
  }
  spec {
    storage_class_name = "do-block-storage"

    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
