resource "google_storage_bucket" "terraform_state" {
  name     = "state0001"
  location = "US"

  # Enable versioning for state bucket
  versioning {
    enabled = true
  }

  # Set lifecycle rule for the state bucket
  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 365  # Adjust as needed for lifecycle policies
    }
  }
}