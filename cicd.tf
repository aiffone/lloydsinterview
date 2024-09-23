resource "google_cloudbuild_trigger" "hello-trigger" {
  location = "us-central1"

  trigger_template {
    branch_name = "main"
    repo_name   = "lloydsinterview"
  }

  substitutions = {
    _FOO = "bar"
    _BAZ = "qux"
  }

  filename = "cloudbuild.yaml"
}