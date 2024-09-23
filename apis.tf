locals {
  api_services = [
    "container.googleapis.com",   # Google Kubernetes Engine (GKE)
    "cloudbuild.googleapis.com",  # Cloud Build
    "monitoring.googleapis.com",  # Cloud Monitoring
    "logging.googleapis.com",     # Cloud Logging
    "storage.googleapis.com",     # Google Cloud Storage
    "compute.googleapis.com",      # Google Compute Engine
    "cloudresourcemanager.googleapis.com" 
    # Add more APIs as needed
  ]
}

# Enable APIs
resource "google_project_service" "apis" {
  for_each = toset(local.api_services)
  project  = "playground-s-11-f447010d"
  service  = each.value
}
