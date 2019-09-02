module "networking_resources_cloudflare" {
  source = "./networking/cloudflare"

  providers = {
    cloudflare = "cloudflare"
  }
}
