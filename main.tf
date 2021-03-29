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

# creates cloud build trigger
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

# creates google logging metric that parses out request data from cloud run invocations
resource "google_logging_metric" "cloud_run_requests" {
  description = "Shows request information for cloud run resources"
  filter      = "resource.type=\"cloud_run_revision\" log_name=~\"/logs/run.googleapis.com%2Frequests\""

  label_extractors = {
    method     = "EXTRACT(httpRequest.requestMethod)"
    remote_ip  = "EXTRACT(httpRequest.remoteIp)"
    server_ip  = "EXTRACT(httpRequest.serverIp)"
    status     = "EXTRACT(httpRequest.status)"
    url        = "EXTRACT(httpRequest.requestUrl)"
    user_agent = "EXTRACT(httpRequest.userAgent)"
  }

  metric_descriptor {
    labels {
      key        = "status"
      value_type = "STRING"
    }

    labels {
      key        = "user_agent"
      value_type = "STRING"
    }

    labels {
      key        = "method"
      value_type = "STRING"
    }

    labels {
      key        = "server_ip"
      value_type = "STRING"
    }

    labels {
      key        = "url"
      value_type = "STRING"
    }

    labels {
      key        = "remote_ip"
      value_type = "STRING"
    }

    metric_kind = "DELTA"
    unit        = "1"
    value_type  = "INT64"
  }

  name    = "cloud-run-requests"
  project = var.project
}
