variable "apikey" {}

provider "digitalocean" {
  token = "${var.apikey}"
}
