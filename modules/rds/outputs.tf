output "db_name" {
  description = "The name of the database"
  value       = module.aurora_postgresql_v2.cluster_database_name
}

output "db_host" {
  description = "The host of the database"
  value       = module.aurora_postgresql_v2.cluster_endpoint
}