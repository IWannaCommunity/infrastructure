// Static Forum Archive
resource "digitalocean_spaces_bucket" "iwc-forum-archive" {
  name   = "iwc-forum-archive"
  region = "sfo2"
  acl    = "private"
}
