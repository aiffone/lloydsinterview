# resource "google_container_cluster" "primary" {
#   name     = var.cluster_name
#   location = var.region

#   network    = google_compute_network.vpc_network.id
#   subnetwork = google_compute_subnetwork.vpc_subnetwork.id

#   initial_node_count =  2 # Set to 0 as we are using a custom node pool

#   # Add necessary configurations if needed (optional)
#   # enable_legacy_abac = false  # Optional: Disables legacy ABAC
#   # remove default node pool if you want to manage it entirely
# }

# resource "google_container_node_pool" "primary_nodes" {
#   cluster    = google_container_cluster.primary.name
#   location   = google_container_cluster.primary.location
#   name       = "${var.cluster_name}-node-pool"
  
#   # node_count is not needed when using autoscaling
#   # node_count = 2  # Start with 2 nodes (remove this line)

#   # Enable autoscaling
#   autoscaling {
#     min_node_count = 2
#     max_node_count = 4
#   }

#   node_config {
#     machine_type = "e2-medium"  # Increased from e2-micro to e2-medium
#     disk_size_gb = 50

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/service.management.readonly",
#       "https://www.googleapis.com/auth/servicecontrol"
#     ]
#   }
# }
