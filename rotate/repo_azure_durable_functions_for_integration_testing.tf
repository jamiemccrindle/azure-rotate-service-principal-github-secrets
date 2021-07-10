module "azure_durable_functions_for_integration_testing_github_repo_azure_connection" {
  source           = "./modules/github_repo_azure_connection"
  subscription_id  = data.azurerm_subscription.current.subscription_id
  tenant_id        = data.azuread_client_config.current.tenant_id
  repository       = "azure-durable-functions-for-integration-testing"
  application_name = "azure-durable-functions-for-integration-testing"
  resource_groups  = ["rg-azure-durable-functions-for-integration-testing-001"]
  location         = "West Europe"
  date             = var.date
}
