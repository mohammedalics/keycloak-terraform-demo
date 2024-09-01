# Generates the backend for all modules.
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    key            = "keycloak/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    bucket         = "mytaxi-terraform-states"
    dynamodb_table = "terraform-lock"
  }
}

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
  client_id     = "${local.terraform-client-id}"
  client_secret = "${local.terraform-client-secret}"
  url           = "${local.url}"
  client_id     = "${local.terraform-client-id}"
  client_secret = "${local.terraform-client-secret}"
}

EOF
}

# Generate the "backend.tf" file for every module.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}