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

module "network" {
  source = "../../modules/network"
  network = var.network_name
  project = var.project_id
  
}

module "database" {
  source        = "../../modules/database"
  instance_name = "test-postgres-instance"
  region        = var.region
  project_id    = var.project_id
  tier          = "db-f1-micro"
  #network       = data.google_compute_network.vpc_network.self_link
  network       = module.network.network_self_link
  db_name       = "appdb"
  db_user       = "appuser"
  db_password   = var.db_password

  depends_on = [module.network]
}

module "storage" {
  source      = "../../modules/storage"
  bucket_name = "${var.project_id}-app-bucket"
  region      = var.region
}

