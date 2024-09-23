resource "google_storage_bucket" "terraform_state" {
  name     = "state0001"
  location = "US"  # Set your bucket location, e.g., "US" or "EU"

  # Optional settings
  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 365  # Adjust as needed for lifecycle policies
    }
  }
}