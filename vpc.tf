# vpc.tf

resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = var.subnetwork_name
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
}
