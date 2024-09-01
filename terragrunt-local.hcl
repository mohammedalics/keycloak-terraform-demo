# Read the local "env.yaml" in every environment.
locals {
  vars = yamldecode(file("${path_relative_to_include()}/env.yaml"))
  environment   = local.vars.environment
  url           = local.vars.url
  client_id     = local.vars.terraform-client-id
  client_secret = local.vars.terraform-client-secret
}

# Generate the "provider.tf" file for every module.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.4.0"
    }
  }
}

provider "keycloak" {
  client_id     = "${local.client_id}"
  client_secret = "${local.client_secret}"
  url           = "${local.url}"
}

EOF
}

# Generate the "backend.tf" file for every module.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "local" {
    workspace_dir = "./terraform.tfstate"
  }
}
EOF
}