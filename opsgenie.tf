# Configure the Opsgenie Provider
provider "opsgenie" {
  api_key = var.opsgenie_key
  api_url = "api.eu.opsgenie.com"
}
