resource "google_container_node_pool" "primary_nodes" {
  cluster  = google_container_cluster.primary.name  # Reference the primary GKE cluster
  location = google_container_cluster.primary.location
  name     = "${var.cluster_name}-node-pool"

  # Enable autoscaling for the node pool
  autoscaling {
    min_node_count = 1
    max_node_count = 3  # Increase max nodes for more resources
  }

  # Node configuration for the custom node pool
  node_config {
    machine_type = "e2-standard-2"  # Change to a type with more resources
    disk_size_gb = 20  # Increase disk size if needed
    disk_type    = "pd-standard"  # Use standard persistent disk
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]
  }
}
