provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_compute_network" "vpc_network" {
  name = var.network_name
}

data "google_compute_subnetwork" "subnet" {
  name   = var.subnet_name
  region = var.region
}

module "webserver" {
  source               = "../../modules/webserver"
  instance_name_prefix  = "test-web"
  machine_type         = "g1-small"
  region               = var.region
  zones                = var.zones
  network              = data.google_compute_network.vpc_network.name
  subnet               = data.google_compute_subnetwork.subnet.name
  image                = "projects/debian-cloud/global/images/family/debian-11"
  initial_size         = 2
  min_size             = 2
  max_size             = 2
}

module "database" {
  source        = "../../modules/database"
  instance_name = "test-postgres-instance"
  region        = var.region
  tier          = "db-f1-micro"
  network       = data.google_compute_network.vpc_network.self_link
  db_name       = "appdb"
  db_user       = "appuser"
  db_password   = var.db_password
}

module "storage" {
  source      = "../../modules/storage"
  bucket_name = "${var.project_id}-app-bucket"
  region      = var.region
}

