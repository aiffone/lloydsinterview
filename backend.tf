terraform {
  backend "gcs" {
    bucket = "state01111"  # Use the static name of the state bucket
    prefix = "terraform/state"
  }
}
