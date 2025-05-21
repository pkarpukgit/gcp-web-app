variable "instance_name_prefix" {
  description = "Prefix for naming instances"
  type        = string
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "g1-small"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-central2"
}

variable "zones" {
  description = "GCP zones"
  type        = list(string)
  default     = [
    "europe-central2-a",
    "europe-central2-b"
  ]
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnet" {
  description = "Subnet name"
  type        = string
}

variable "image" {
  description = "Boot disk image"
  type        = string
  default     = "projects/debian-cloud/global/images/family/debian-12"
}

variable "initial_size" {
  description = "Initial size of instance group"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum size of autoscaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of autoscaling group"
  type        = number
  default     = 2
}

