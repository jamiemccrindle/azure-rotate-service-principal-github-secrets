locals {
  date        = tonumber(var.date)
  odd_keeper  = floor((local.date + 1) / 2)
  even_keeper = floor(local.date / 2)
  use_even    = local.date % 2 == 0
}

data "azuread_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

resource "azuread_application" "example" {
  display_name = "example"
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.object_id
}

resource "azuread_application_password" "odd" {
  application_object_id = azuread_application.example.id
  description       = "odd"
  value             = random_password.odd.result
  end_date_relative = "1440h"
}

resource "random_password" "odd" {
  keepers = {
    "date" = local.odd_keeper
  }
  length           = 36
  special          = false
}

resource "azuread_application_password" "even" {
  application_object_id = azuread_application.example.id
  description       = "even"
  value             = random_password.odd.result
  end_date_relative = "1440h"
}

resource "random_password" "even" {
  keepers = {
    "date" = local.even_keeper
  }
  length           = 36
  special          = false
}

resource "github_actions_secret" "example" {
  repository      = "azure-rotate-service-principal-github-secrets"
  secret_name     = "AZURE_CREDENTIALS"
  plaintext_value = <<-EOT
{
  "clientId": "${azuread_application.example.application_id}",
  "clientSecret": "${local.use_even ? random_password.even.result : random_password.odd.result}",
  "subscriptionId": "${data.azurerm_subscription.current.subscription_id}",
  "tenantId": "${data.azuread_client_config.current.tenant_id}",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
EOT
  
  
}

output "secret" {
  value = github_actions_secret.example.plaintext_value
}