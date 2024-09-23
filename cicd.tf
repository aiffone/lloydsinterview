resource "google_cloudbuild_trigger" "trigger" {
  name = "build-trigger"

  # Event type to trigger build (GitHub, Cloud Source Repos, etc.)
  github {
    owner        = "aiffone"
    name         = "lloydsinterview"
    push {
      branch = "^main$"  # Regex for branch (e.g., trigger on "main" branch)
    }
  }

  # Specify the build steps (inline or file)
  filename = "cloudbuild.yaml"  # Path to your cloudbuild.yaml file

  # Optional: Define any substitutions you might need
  substitutions = {
    _CUSTOM_SUBSTITUTION = "custom_value"
  }

  # Optional: Define the tags for the build trigger
  tags = ["hello", "build-trigger"]

  # Optional: Define the service account that Cloud Build should use
  service_account = "cli-service-account-1@playground-s-11-f447010d.iam.gserviceaccount.com"
}