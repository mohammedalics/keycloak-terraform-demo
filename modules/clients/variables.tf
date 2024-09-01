variable "realm_id" {
  description = "Realm ID"
  type        = string
}

variable "client_id" {
  description = "Client id"
  type        = string
}

variable "client_secret" {
  description = "Client secret"
  type        = string
  sensitive   = true
}

variable "common_client_scope" {
  description = "common client scope name"
  type        = string
}

variable "client_scopes" {
  description = "client scopes names"
  type        = list(string)
}

variable "valid_redirect_uris" {
  description = "redirect uris"
  type        = list(string)
  default     = ["https://oauthdebugger.com/debug"]
}