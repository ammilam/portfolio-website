provider "google" {}

resource "google_cloudbuild_trigger" "portfolio_website" {
  provider = "google-beta"
  filename = "cloudbuild.yaml"
  name     = "portfolio-website"
  project  = var.project
  github {
    owner = var.repo_owner
    name  = var.repo
    push {
      branch = "^main$"
    }

  }
}