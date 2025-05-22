resource "google_compute_instance_template" "web_template" {
  name_prefix = "${var.instance_name_prefix}-template"
  machine_type = var.machine_type
  region       = var.region

  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
    access_config {} # ephemeral external IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF

  lifecycle {
    create_before_destroy = true
  }

  tags = ["${var.instance_name_prefix}-tag","web-server"]
}

resource "google_compute_region_instance_group_manager" "web_igm" {
  name               = "${var.instance_name_prefix}-igm"
  base_instance_name  = var.instance_name_prefix
  target_size        = var.initial_size

  version {
    instance_template = google_compute_instance_template.web_template.id
    name              = "v1"
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.web_health_check.self_link
    initial_delay_sec = 300
  }
  
  distribution_policy_zones = var.zones
}

resource "google_compute_health_check" "web_health_check" {
  name = "${var.instance_name_prefix}-hc"
  http_health_check {
    port = 80
    request_path = "/"
  }
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

resource "google_compute_region_autoscaler" "web_autoscaler" {
  name   = "${var.instance_name_prefix}-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.web_igm.id

  autoscaling_policy {
    max_replicas    = var.max_size
    min_replicas    = var.min_size
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_backend_service" "web_backend" {
  name                  = "${var.instance_name_prefix}-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.web_health_check.self_link]
  backend {
    group = google_compute_region_instance_group_manager.web_igm.instance_group
  }
}

resource "google_compute_url_map" "web_url_map" {
  name            = "${var.instance_name_prefix}-url-map"
  default_service = google_compute_backend_service.web_backend.self_link
}

resource "google_compute_target_http_proxy" "web_http_proxy" {
  name    = "${var.instance_name_prefix}-http-proxy"
  url_map = google_compute_url_map.web_url_map.self_link
}

resource "google_compute_global_forwarding_rule" "web_forwarding_rule" {
  name       = "${var.instance_name_prefix}-forwarding-rule"
  target     = google_compute_target_http_proxy.web_http_proxy.self_link
  port_range = "80"
}

