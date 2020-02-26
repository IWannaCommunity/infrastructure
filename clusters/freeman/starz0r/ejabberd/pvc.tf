resource "kubernetes_persistent_volume_claim" "ejabberd-certs" {
  metadata {
    name = "freeman-starz0r-ejabberd-certs"
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
