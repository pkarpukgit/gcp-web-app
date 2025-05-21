variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-central2"
}

