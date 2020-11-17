resource "google_cloud_run_service" "cards" {
  name = "container-runner"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/devops-examen-2020/card@sha256:21fa9c1d5e5c2520506f0b5054aa4f9623df9977304d95b4860e77236a212095"
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