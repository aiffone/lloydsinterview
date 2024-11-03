terraform {
  backend "gcs" {
    bucket = "statekayprov01"  # Use the static name of the state bucket
    prefix = "terraform/state"
  }
}
