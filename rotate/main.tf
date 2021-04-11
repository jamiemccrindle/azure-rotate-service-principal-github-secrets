locals {
  date        = tonumber(var.date)
  odd_keeper  = floor((local.date + 1) / 2)
  even_keeper = floor(local.date / 2)
  use_even    = local.date % 2 == 0
}

resource "azuread_application" "example" {
  display_name = "example"
}

resource "azuread_application_password" "odd" {
  application_object_id = azuread_application.example.id
  description           = "odd"
  value                 = random_password.odd.result
  end_date_relative     = "1440h"
}

resource "random_password" "odd" {
  keepers = {
    "date" = local.odd_keeper
  }
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azuread_application_password" "even" {
  application_object_id = azuread_application.example.id
  description           = "even"
  value                 = random_password.odd.result
  end_date_relative     = "1440h"
}

resource "random_password" "even" {
  keepers = {
    "date" = local.even_keeper
  }
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "github_actions_secret" "example" {
  repository      = "azure-rotate-service-principal-github-secrets"
  secret_name     = "AZURE_SERVICE_PRINCIPAL"
  plaintext_value = local.use_even ? random_password.even.result : random_password.odd.result
}
