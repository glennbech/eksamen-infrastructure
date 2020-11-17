provider "statuscake" {
  username = "armingubergmailcom"
  apikey   = var.statuscake_key
}

resource "statuscake_test" "google_status_cake" {
  website_name = "My container app"
  website_url  = google_cloud_run_service.cards.status[0].url
  test_type    = "HTTP"
  check_rate   = 100
  contact_group = ["194947"]
}