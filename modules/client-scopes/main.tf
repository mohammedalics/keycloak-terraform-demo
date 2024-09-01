# "common" scope
resource "keycloak_openid_client_scope" "common_client_scope" {
  realm_id               = var.realm_id
  name                   = "common"
  description            = "The scope is designed to be considered by all the clients"
  include_in_token_scope = false
}

## common scope protocol mappers
resource "keycloak_openid_user_property_protocol_mapper" "username_user_property_mapper" {
  realm_id            = var.realm_id
  client_scope_id     = keycloak_openid_client_scope.common_client_scope.id
  name                = "sub"
  add_to_id_token     = false
  add_to_userinfo     = false
  add_to_access_token = true

  user_property    = "username"
  claim_value_type = "String"
  claim_name       = "sub"
}

# "read only" scope
resource "keycloak_openid_client_scope" "read_only_client_scope" {
  realm_id               = var.realm_id
  name                   = "read_only"
  description            = "read only scope"
  include_in_token_scope = true
}
