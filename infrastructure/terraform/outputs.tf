output "database_id" {
  description = "ID of the forum D1 database"
  value       = cloudflare_d1_database.forum.id
}

output "database_name" {
  description = "Name of the forum D1 database"
  value       = cloudflare_d1_database.forum.name
}