## Define locals
locals {
  environment = "prod"

  kc_admin_client_id     = "terraform"
  kc_admin_client_secret = "terraform"
}

# Define master realm
module "realm-master" {
  source = "../modules/realm-master"
}
