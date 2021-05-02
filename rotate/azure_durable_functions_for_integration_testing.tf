resource "azurerm_resource_group" "azure_durable_functions_for_integration_testing" {
  name     = "rg-azure-durable-functions-for-integration-testing-001"
  location = "West Europe"
}

resource "azuread_application" "azure_durable_functions_for_integration_testing" {
  display_name = "azure-durable-functions-for-integration-testing"
}

resource "azuread_service_principal" "azure_durable_functions_for_integration_testing" {
  application_id = azuread_application.azure_durable_functions_for_integration_testing.application_id
}

resource "azurerm_role_assignment" "azure_durable_functions_for_integration_testing" {
  scope                = azurerm_resource_group.azure_durable_functions_for_integration_testing.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.azure_durable_functions_for_integration_testing.object_id
}

module "azure_durable_functions_for_integration_testing_sp_secrets" {
  source                = "./modules/azure_github_secrets"
  subscription_id       = data.azurerm_subscription.current.subscription_id
  tenant_id             = data.azuread_client_config.current.tenant_id
  repository            = "azure-durable-functions-for-integration-testing"
  application_id        = azuread_application.azure_durable_functions_for_integration_testing.application_id
  application_object_id = azuread_application.azure_durable_functions_for_integration_testing.id
  date                  = var.date
}