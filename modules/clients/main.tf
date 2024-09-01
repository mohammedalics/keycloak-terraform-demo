resource "keycloak_openid_client" "test" {
  realm_id                     = var.realm_id
  client_id                    = var.client_id
  client_secret                = var.client_secret
  name                         = var.client_id
  access_type                  = "CONFIDENTIAL"
  enabled                      = true
  standard_flow_enabled        = true
  implicit_flow_enabled        = true
  direct_access_grants_enabled = true
  service_accounts_enabled     = true
  use_refresh_tokens           = true
  valid_redirect_uris          = var.valid_redirect_uris

}

resource "keycloak_openid_client_default_scopes" "test_client_default_scopes" {
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.test.id

  default_scopes = [
    var.common_client_scope
  ]
}

resource "keycloak_openid_client_optional_scopes" "test_client_optional_scopes" {
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.test.id

  optional_scopes = concat([
    "acr",
    "address",
    "email",
    "microprofile-jwt",
    "offline_access",
    "phone",
    "profile",
    "roles",
    "web-origins"
  ], var.client_scopes)
}

