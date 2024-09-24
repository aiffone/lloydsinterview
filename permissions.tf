# Get the Cloud Build service account
data "google_project" "project" {}

data "google_service_account" "cloud_build_sa" {
  account_id = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Grant Kubernetes Engine Developer role
resource "google_project_iam_binding" "cloud_build_kubernetes_developer" {
  project = var.project_id
  role    = "roles/container.developer"

  members = [
    "serviceAccount:${data.google_service_account.cloud_build_sa.email}"
  ]
}

# Grant Kubernetes Engine Admin role
resource "google_project_iam_binding" "cloud_build_kubernetes_admin" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${data.google_service_account.cloud_build_sa.email}"
  ]
}

# Grant Cloud Build Editor role
resource "google_project_iam_binding" "cloud_build_editor" {
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"

  members = [
    "serviceAccount:${data.google_service_account.cloud_build_sa.email}"
  ]
}

# Grant Viewer role (optional, if needed for read-only access)
resource "google_project_iam_binding" "cloud_build_viewer" {
  project = var.project_id
  role    = "roles/viewer"

  members = [
    "serviceAccount:${data.google_service_account.cloud_build_sa.email}"
  ]
}

# Grant Storage Admin role (optional, if needed for GCS access)
resource "google_project_iam_binding" "cloud_build_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${data.google_service_account.cloud_build_sa.email}"
  ]
}
