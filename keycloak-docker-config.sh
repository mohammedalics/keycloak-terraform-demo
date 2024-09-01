#!/bin/bash

apt update -y && apt -y install jq curl

until $(curl --output /dev/null --silent --head --fail http://keycloak:8080/keycloak); do
    printf '.'
    sleep 5
done

# Get access token
TOKEN=$( \
  curl -X POST \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=admin-cli" \
    -d "username=admin" \
    -d "password=admin" \
    -d "grant_type=password" \
    "http://keycloak:8080/keycloak/realms/master/protocol/openid-connect/token" | jq -r '.access_token')

# Create Terraform client (terraform/terraform)
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '{"clientId": "terraform", "name": "terraform", "enabled": true, "publicClient": false, "secret": "terraform", "serviceAccountsEnabled": true}' \
  "http://keycloak:8080/keycloak/admin/realms/master/clients"

# Get the Terraform service account user ID
USER_ID=$( \
  curl -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TOKEN}" \
    "http://keycloak:8080/keycloak/admin/realms/master/users?username=service-account-terraform" | jq -r '.[0].id')

# Get the admin role ID
ROLE_ID=$( \
  curl -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TOKEN}" \
    "http://keycloak:8080/keycloak/admin/realms/master/roles" | jq -r '.[] | select(.name == "admin") | .id')

# Add the admin role to the Terraform service account user
curl -kv -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d '[{"id":"'"${ROLE_ID}"'", "name":"admin"}]' \
  "http://keycloak:8080/keycloak/admin/realms/master/users/$USER_ID/role-mappings/realm"