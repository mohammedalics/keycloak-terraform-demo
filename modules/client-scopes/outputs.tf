output "common_client_scope_name" {
  value = keycloak_openid_client_scope.common_client_scope.name
}

output "ready_only_client_scope_name" {
  value = keycloak_openid_client_scope.read_only_client_scope.name
}