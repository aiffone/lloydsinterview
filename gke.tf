# Define a new variable for the region
variable "infra_region" {
  description = "The GCP region to create the clusters in"
  default     = "us-central1"
}

variable "infra1_cluster_name" {
  description = "The name of the first cluster"
  default     = "infra1"
}

variable "infra2_cluster_name" {
  description = "The name of the second cluster"
  default     = "infra2"
}

# Create the first GKE cluster
resource "google_container_cluster" "infra1" {
  name     = var.infra1_cluster_name
  location = var.infra_region  # Use the new region variable

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 10
    disk_type    = "pd-standard"
  }

  remove_default_node_pool = true
}

# Create the node pool for the first cluster
resource "google_container_node_pool" "infra1_nodes" {
  cluster  = google_container_cluster.infra1.name
  location = google_container_cluster.infra1.location
  name     = "${var.infra1_cluster_name}-node-pool"

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 10
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }
}

# Create the second GKE cluster
resource "google_container_cluster" "infra2" {
  name     = var.infra2_cluster_name
  location = var.infra_region  # Use the new region variable

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 10
    disk_type    = "pd-standard"
  }

  remove_default_node_pool = true
}

# Create the node pool for the second cluster
resource "google_container_node_pool" "infra2_nodes" {
  cluster  = google_container_cluster.infra2.name
  location = google_container_cluster.infra2.location
  name     = "${var.infra2_cluster_name}-node-pool"

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 10
    disk_type    = "pd-standard"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }
}

# Optional: Outputs for cluster endpoints
output "infra1_endpoint" {
  value = google_container_cluster.infra1.endpoint
}

output "infra2_endpoint" {
  value = google_container_cluster.infra2.endpoint
}
