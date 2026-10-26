
resource "cloudflare_d1_database" "forum" {
  account_id = var.account_id
  name       = "mini-forum-dev"
}

resource "cloudflare_workers_script" "forum_worker" {
  account_id  = var.account_id
  script_name = "mini-forum-prod"

  content_file   = "${path.module}/index.js"
  content_sha256 = filesha256("${path.module}/index.js")
  main_module    = "index.js"

  compatibility_date = "2026-08-06"

  bindings = [
      {
        name = "DB"
        type = "d1"
        id   = cloudflare_d1_database.forum.id
      },
      {
        name         = "ASSETS"
        type         = "kv_namespace"
        namespace_id = cloudflare_workers_kv_namespace.forum_assets.id
      }
    ]
}

resource "cloudflare_workers_kv_namespace" "forum_assets" {
  account_id = var.account_id
  title      = "mini-forum-assets"
}