output "instance_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = google_sql_database_instance.postgres_instance.connection_name
}

output "database_name" {
  description = "Database name"
  value       = google_sql_database.app_db.name
}

