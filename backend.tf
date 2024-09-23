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

# New bucket for Cloud Build logs
resource "google_storage_bucket" "cloudbuild_logs" {
  name     = "cloudbuild-logs-0001-hellointerview"  # Ensure this name is unique in GCS
  location = "US"  # Set to the appropriate location

  # Optional settings for logs bucket
  versioning {
    enabled = false  # Logs bucket doesn't need versioning
  }

  # Optional lifecycle rule for log retention
  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 30  # Retain logs for 30 days, adjust as needed
    }
  }

  # Enable uniform access control for the bucket
  uniform_bucket_level_access = true
}

