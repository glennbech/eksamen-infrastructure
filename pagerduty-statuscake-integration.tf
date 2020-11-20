resource "pagerduty_service" "eu_service" {
  name                    = "My Web App"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.eu_escalation_policy.id
}

resource "pagerduty_service_integration" "status_cake_integration" {
  name    = "Generic API Service Integration"
  type    = "generic_events_api_inbound_integration"
  service = pagerduty_service.eu_service.id
}

resource "pagerduty_service_integration" "apiv2" {
  name = "API V2"
  type = "events_api_v2_inbound_integration"
  integration_key = var.pagerduty_token
  service = pagerduty_service.eu_service.id
}

data "pagerduty_vendor" "statuscake" {
  name = "Statuscake"
}