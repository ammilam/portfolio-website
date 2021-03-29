provider "google" {}

resource "google_project_service" "project" {
  project = var.project
  for_each = toset([
    "cloudbuild.googleapis.com",
    "cloudrun.googleapis.com",

  ])
  service = "iam.googleapis.com"

  disable_dependent_services = false
}

resource "google_cloudbuild_trigger" "portfolio_website" {
  provider = google-beta
  filename = "cloudbuild.yaml"
  name     = "portfolio-website"
  project  = var.project
  github {
    owner = var.repo_owner
    name  = var.repo
    push {
      branch = "main"
    }
  }
  depends_on = [google_project_service.project]
}