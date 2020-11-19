resource "google_cloud_run_service" "cards" {
  name = "container-runner"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/devops-examen-2020/card@sha256:e80d41ad0d507b56ba54f191e9a6ba76b4411d6656ca638b1d3c92ceebb740b0"
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