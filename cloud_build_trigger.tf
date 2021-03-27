provider "google" {}

data "template_file" "init" {
  template = "${file("${path.module}/cloudbuild.yaml.tpl")}"
  vars = {
    NAME = "${var.name}"
  }
}

resource "local_file" "yaml" {
  content  = data.template_file.init.rendered
  filename = "cloudbuild.yaml"
}
resource "google_cloudbuild_trigger" "portfolio_website" {
  provider = "google-beta"
  filename = data.template_file.init.rendered
  name     = var.name
  project  = var.project
  github {
    owner = var.repo_owner
    name  = var.repo
    push {
      branch = "feat/cian-website"
    }

  }
  depends_on = [local_file.yaml]
}

resource "google_project_service" "project" {
  project = var.project
  for_each = toset([
    "cloudbuild.googleapis.com",
    "cloudrun.googleapis.com",

  ])
  service = "iam.googleapis.com"

  disable_dependent_services = false
}