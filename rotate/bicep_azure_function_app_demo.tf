resource "azurerm_resource_group" "bicep_azure_function_app_demo" {
  name     = "rg-bicep-azure-function-app-demo-001"
  location = "West Europe"
}

resource "azuread_application" "bicep_azure_function_app_demo" {
  display_name = "bicep-azure-function-app-demo"
}

resource "azuread_service_principal" "bicep_azure_function_app_demo" {
  application_id = azuread_application.bicep_azure_function_app_demo.application_id
}

resource "azurerm_role_assignment" "bicep_azure_function_app_demo" {
  scope                = azurerm_resource_group.bicep_azure_function_app_demo.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.bicep_azure_function_app_demo.object_id
}

module "bicep_azure_function_app_demo_sp_secrets" {
  source                = "./modules/azure_github_secrets"
  subscription_id       = data.azurerm_subscription.current.subscription_id
  tenant_id             = data.azuread_client_config.current.tenant_id
  repository            = "bicep-azure-function-app-demo"
  application_id        = azuread_application.bicep_azure_function_app_demo.application_id
  application_object_id = azuread_application.bicep_azure_function_app_demo.id
  date                  = var.date
}