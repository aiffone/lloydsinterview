# GKE Cluster and Node Pool Configuration

# Define the GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Define the network and subnetwork for the cluster
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.vpc_subnetwork.id

  # Initial node count set to 0 because we're using a custom node pool below.
  initial_node_count = 1

  # Optional: Specify the node configuration to use standard disks instead of SSDs
  node_config {
    machine_type = "e2-medium"  # Select the appropriate machine type
    disk_size_gb = 20  # Increased disk size to 20 GB for more storage
    disk_type    = "pd-standard"  # Use standard persistent disk to reduce SSD quota usage
  }

  # Remove the default node pool, as we are defining our custom node pool below 
  remove_default_node_pool = true
}

# Define a custom node pool for the GKE cluster
resource "google_container_node_pool" "primary_nodes" {
  cluster  = google_container_cluster.primary.name  # Reference the primary GKE cluster
  location = google_container_cluster.primary.location
  name     = "${var.cluster_name}-node-pool"

  # Enable autoscaling for the node pool
  autoscaling {
    min_node_count = 1
    max_node_count = 5  # Increased max node count to allow scaling up to 5 nodes
  }

  # Node configuration for the custom node pool
  node_config {
    machine_type = "e2-standard-2"  # Upgraded machine type to e2-standard-2 for more resources
    disk_size_gb = 20  # Increased disk size to 20 GB for more storage
    disk_type    = "pd-standard"  # Use standard persistent disk to avoid SSD quota issue
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }
}
