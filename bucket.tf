# Terraform state bucket
resource "google_storage_bucket" "terraform_state" {
  name     = "state0001"
  location = "US"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 365
    }
  }
}

# Cloud Build logs bucket
resource "google_storage_bucket" "cloudbuild_logs" {
  name     = "cloudbuild-logs-0001"
  location = "US"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = 30
    }
  }

  uniform_bucket_level_access = true
}
