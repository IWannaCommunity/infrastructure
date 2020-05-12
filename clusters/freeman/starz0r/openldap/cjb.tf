resource "kubernetes_cron_job" "certbot" {
  metadata {
    name = "certbot-starz0r-openldap"
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "0 12 * * 6"
    starting_deadline_seconds     = 30
    successful_jobs_history_limit = 10
    suspend                       = false
    job_template {
      metadata {}
      spec {
        backoff_limit = 2
        template {
          metadata {}
          spec {
            container {
              name  = "certbot"
              image = "certbot/dns-cloudflare@sha256:be7b8cb56b3167e8c49de0436c4815af1db4404135c4fc42b9badb68b5850496" // v1.4.0-amd64
              args  = ["certonly", "-vvv", "--non-interactive", "-m", "starz0rdesign@gmail.com", "--agree-tos", "--dns-cloudflare", "--dns-cloudflare-credentials", "/etc/letsencrypt/cloudflare.ini", "--dns-cloudflare-propagation-seconds", "60", "-d", "ldaps.starz0r.com"]
              volume_mount {
                name       = "config"
                mount_path = "/etc/letsencrypt/cloudflare.ini"
                sub_path   = "cloudflare.ini"
              }
              volume_mount {
                name       = "certs"
                mount_path = "/etc/letsencrypt"
              }
            }
            restart_policy = "OnFailure"

            volume {
              name = "config"
              config_map {
                name = "certbot"
              }
            }
            volume {
              name = "certs"
              persistent_volume_claim {
                claim_name = "${kubernetes_persistent_volume_claim.openldap-certs.metadata.0.name}"
              }
            }
          }
        }
      }
    }
  }
}
