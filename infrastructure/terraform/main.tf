
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
    }
  ]
}

