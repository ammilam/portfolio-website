provider "google" {}

resource "google_cloudbuild_trigger" "portfolio_website" {
  provider = "google-beta"
  filename = "cloudbuild.yaml"
  name     = "portfolio-website"
  github {
    owner = "ammilam"
    name  = "portfolio-website"
    push {
      branch = "^main$"
    }

  }
}