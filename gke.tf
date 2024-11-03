# GKE Cluster and Node Pool Configuration

# Define the GKE Cluster
resource "google_container_cluster" "infra1_gke_cluster" {
  name     = "infra1-gke-cluster"  # Set the name of the GKE cluster
  location = var.region             # Reference the region variable

  # Define the network and subnetwork for the cluster
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.vpc_subnetwork.id

  # Initial node count set to 1 as a placeholder
  initial_node_count = 1

  # Node configuration for the GKE cluster
  node_config {
    machine_type = "e2-medium"      # Select the appropriate machine type
    disk_size_gb = 10               # Set disk size to 10 GB
    disk_type    = "pd-standard"     # Use standard persistent disk
  }

  # Remove the default node pool since we will create a custom node pool
  remove_default_node_pool = true
}

# Define a custom node pool for the GKE cluster
resource "google_container_node_pool" "infra1_nodes" {
  cluster  = google_container_cluster.infra1_gke_cluster.name  # Reference the GKE cluster
  location = google_container_cluster.infra1_gke_cluster.location
  name     = "infra1-gke-cluster-node-pool"  # Name the node pool accordingly

  # Enable autoscaling for the node pool
  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  # Node configuration for the custom node pool
  node_config {
    machine_type = "e2-medium"    # Select the appropriate machine type
    disk_size_gb = 10             # Set disk size to 10 GB
    disk_type    = "pd-standard"   # Use standard persistent disk
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }
}

# Optional: Outputs for cluster endpoint
output "infra1_gke_cluster_endpoint" {
  value = google_container_cluster.infra1_gke_cluster.endpoint
}
