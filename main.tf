resource "google_cloud_run_service" "cards" {
  name = "container-runner"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/devops-examen-2020/card@sha256:876edc796a3c6edd0ee32fca3b3b9aad39e309c6db3e1b1bc79fdabb8f3f36d2"
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