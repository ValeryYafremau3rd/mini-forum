
resource "cloudflare_d1_database" "forum" {
  account_id = var.account_id
  name       = "mini-forum-dev"
}
