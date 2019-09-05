resource "kubernetes_persistent_volume_claim" "openldap-data" {
  metadata {
    name = "freeman-starz0r-openldap-data"
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

resource "kubernetes_persistent_volume_claim" "openldap-config" {
  metadata {
    name = "freeman-starz0r-openldap-config"
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

resource "kubernetes_persistent_volume_claim" "openldap-certs" {
  metadata {
    name = "freeman-starz0r-openldap-certs"
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
