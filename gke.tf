resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.vpc_subnetwork.id

  initial_node_count = 0  # Set to 0 as we are using a custom node pool

  # Configure IP allocation policy for IP aliasing
  ip_allocation_policy {
    use_ip_aliases = true
    cluster_ipv4_cidr_block = "10.0.0.0/14" # Example CIDR block for cluster IPs
    services_ipv4_cidr_block = "10.0.4.0/20" # Example CIDR block for service IPs
  }

  remove_default_node_pool = true  # We are creating our own node pool
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  name       = "${var.cluster_name}-node-pool"
  
  node_count = 2  # Start with 2 nodes

  # Enable autoscaling
  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }

  node_config {
    machine_type = "e2-medium"  # Increased from e2-micro to e2-medium
    disk_size_gb = 50

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }
}
