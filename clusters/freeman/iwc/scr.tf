resource "kubernetes_secret" "registry-public-code" {
  metadata {
    name      = "registry-public-code"
    namespace = "iwc"
  }

  data = {
    ".dockerconfigjson" = "${file("${path.module}/registry-public-code.secret")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}
