resource "azuread_application" "example" {
  display_name               = "example"
}

resource "azuread_application_password" "odd" {
  application_object_id = azuread_application.example.id
  description           = "odd"
  value                 = random_password.odd.result
  end_date_relative     = "60d"
}

resource "random_password" "odd" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "github_actions_secret" "example" {
  repository       = "azure-rotate-service-principal-github-secrets"
  secret_name      = "AZURE_SERVICE_PRINCIPAL"
  plaintext_value  = random_password.odd.result
}
