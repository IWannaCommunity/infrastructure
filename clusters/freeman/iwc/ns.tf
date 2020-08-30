resource "kubernetes_namespace" "iwc" {
  metadata {
    name = "iwc"
  }
}

# AutoMod
variable "automod_discord_token" {}
module "automod" {
  source = "./automod"

  discord_token = "${var.automod_discord_token}"
}
