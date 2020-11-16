resource "google_cloud_run_service" "cards" {
  name = "container-runner"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/devops-examen-2020/card@sha256:ba7ea3e84d9b1baea947c1f248e3029bad52a222986a6d3e42cad3f6e4a7557a"
        env {
          name = "LOGZ_TOKEN"
          value = var.logz_token
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