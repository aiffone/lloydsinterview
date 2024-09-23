terraform {
  backend "gcs" {
    bucket = google_storage_bucket.terraform_state.name
    prefix = "terraform/state"
  }
}
