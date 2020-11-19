resource "google_monitoring_uptime_check_config" "uptime-check" {
  display_name = "http-uptime-check"
  timeout      = "60s"

  http_check {
    path = "/api"
    port = "8080"
    request_method = "GET"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = google_cloud_run_service.cards.status[0].url
    }
  }
  project = var.project_id

  content_matchers {
    content = "Wellcome to homepage"
  }
  lifecycle {
    create_before_destroy = true
  }
}