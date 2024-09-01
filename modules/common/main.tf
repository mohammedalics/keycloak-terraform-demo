resource "keycloak_realm_events" "realm_events" {
  realm_id                     = var.realm_id
  events_enabled               = true
  events_expiration            = 1800
  admin_events_enabled         = false
  admin_events_details_enabled = false

  # When omitted or left empty, keycloak will enable all event types
  enabled_event_types = [
    "LOGIN"
  ]

  events_listeners = [
    "jboss-logging"
  ]
}