## Define locals
locals {
  environment            = "local"
  kc_admin_client_id     = "terraform"
  kc_admin_client_secret = "terraform"
  test_client_secret     = "secret"
}

# Define master realm
module "realm-master" {
  source = "../modules/realm-master"
}

## Define client scopes
module "client-scopes-master" {
  source   = "../modules/client-scopes"
  realm_id = module.realm-master.realm_master_id
}

## Define clients
### Define test client
module "test-client" {
  source              = "../modules/clients"
  realm_id            = module.realm-master.realm_master_id
  client_id           = "test-client"
  client_secret       = local.test_client_secret
  common_client_scope = module.client-scopes-master.common_client_scope_name
  client_scopes = [module.client-scopes-master.ready_only_client_scope_name]
  depends_on = [module.realm-master, module.client-scopes-master]
}