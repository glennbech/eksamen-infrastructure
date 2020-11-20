resource "google_cloud_run_service" "cards" {
  name = "container-runner"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/devops-examen-2020/card@sha256:1e632ea68e0304890e9653c9080ebeaa35fd8fa5d92c8348d292ffb1d98b992b"
        env {
          name = "LOGZ_TOKEN"
          value = var.logz_token
        }
        env {
          name = "LOGZ_URL"
          value = var.logz_url
        }
      }
    }
  }

  traffic {
    percent = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.cards.location
  project = google_cloud_run_service.cards.project
  service = google_cloud_run_service.cards.name
  policy_data = data.google_iam_policy.noauth.policy_data
}