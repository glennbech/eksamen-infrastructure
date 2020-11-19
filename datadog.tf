provider "datadog" {
  api_key = var.api_key
  app_key = var.app_key
  api_url = "https://api.datadoghq.eu/"
}


# Create a new Datadog - Google Cloud Platform integration
resource "datadog_integration_gcp" "awesome_gcp_project_integration" {
  project_id     = local.gcp_json_data.project_id
  private_key_id = local.gcp_json_data.private_key_id
  private_key    = local.gcp_json_data.private_key
  client_email   = local.gcp_json_data.client_email
  client_id      = local.gcp_json_data.client_id
}
