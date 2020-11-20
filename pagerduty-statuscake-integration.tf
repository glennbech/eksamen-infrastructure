resource "pagerduty_service" "statuscake_service" {
  name                    = "Eksamen web app - statuscake"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = pagerduty_escalation_policy.eu_escalation_policy.id
}

#Get api key to connect statuscake
resource "pagerduty_service_integration" "status_cake_integration" {
  name    = "Statuscake API Service Integration"
  type    = "generic_events_api_inbound_integration"
  service = pagerduty_service.statuscake_service.id
}
