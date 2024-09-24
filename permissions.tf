# Define the project where the roles will be assigned
data "google_project" "project" {}

# Define the service account
variable "service_account_email" {
  default = "cli-service-account-1@playground-s-11-206df3f9.iam.gserviceaccount.com"
}

# Grant Kubernetes Engine Developer role
resource "google_project_iam_binding" "kubernetes_developer" {
  project = var.project_id
  role    = "roles/container.developer"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

# Grant Kubernetes Engine Admin role
resource "google_project_iam_binding" "kubernetes_admin" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

# Grant Cloud Build Editor role
resource "google_project_iam_binding" "cloud_build_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

# Grant Viewer role (optional, if needed for read-only access)
resource "google_project_iam_binding" "viewer" {
  project = var.project_id
  role    = "roles/viewer"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

# Grant Storage Admin role (optional, if needed for GCS access)
resource "google_project_iam_binding" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}
