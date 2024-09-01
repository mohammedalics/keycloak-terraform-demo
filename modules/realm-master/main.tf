data "keycloak_realm" "master" {
  realm = "master"
}

module "realm-master" {
  source   = "../../modules/common"
  realm_id = data.keycloak_realm.master.id
}