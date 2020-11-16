resource "google_cloud_run_service" "hello" {
  name = "helloworld-service"
  location = "us-central1"
  project = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/devops-examen-2020/card@sha256:5fab743f600a10cd1e49e7fa25d332e86df7c0bcf3fe4291f484d11268890830"
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
  location = google_cloud_run_service.hello.location
  project = google_cloud_run_service.hello.project
  service = google_cloud_run_service.hello.name
  policy_data = data.google_iam_policy.noauth.policy_data
}