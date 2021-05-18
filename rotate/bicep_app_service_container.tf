module "bicep_app_service_container_github_repo_azure_connection" {
  source           = "./modules/github_repo_azure_connection"
  subscription_id  = data.azurerm_subscription.current.subscription_id
  tenant_id        = data.azuread_client_config.current.tenant_id
  repository       = "bicep-app-service-container"
  application_name = "bicep-app-service-container"
  resource_groups  = ["rg-bicep-app-service-container-001"]
  location         = "West Europe"
  date             = var.date
}
