output "bucket_name" {
  description = "Name of the created bucket"
  value       = google_storage_bucket.app_bucket.name
}

