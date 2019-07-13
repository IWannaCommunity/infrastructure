resource "cloudflare_zone" "starz0r" {
  zone = "starz0r.com"
}

resource "cloudflare_record" "quassel" {
  domain = "${cloudflare_zone.starz0r}"
  name   = "quassel"
  value  = "${kubernetes_service.quassel.load_balancer_ingress.ip}"
  type   = "A"
  ttl    = 3600
}
