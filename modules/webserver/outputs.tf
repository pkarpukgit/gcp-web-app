output "instance_group_manager_name" {
  description = "Name of the instance group manager"
  value       = google_compute_region_instance_group_manager.web_igm.name
}

output "backend_service_name" {
  description = "Name of the backend service"
  value       = google_compute_backend_service.web_backend.name
}

output "forwarding_rule_ip" {
  description = "IP address of the load balancer"
  value       = google_compute_global_forwarding_rule.web_forwarding_rule.ip_address
}

