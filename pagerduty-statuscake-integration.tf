resource "pagerduty_service" "eu_service" {
  name                    = "Eksamen web app"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.eu_escalation_policy.id
}

resource "pagerduty_service_integration" "status_cake_integration" {
  name    = "Statuscake API Service Integration"
  type    = "generic_events_api_inbound_integration"
  service = pagerduty_service.eu_service.id
}
