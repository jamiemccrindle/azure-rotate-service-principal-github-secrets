module "bicep_teams_bot_github_repo_azure_connection" {
  source           = "./modules/github_repo_azure_connection"
  subscription_id  = data.azurerm_subscription.current.subscription_id
  tenant_id        = data.azuread_client_config.current.tenant_id
  repository       = "bicep-teams-bot"
  application_name = "bicep-teams-bot"
  resource_groups  = ["rg-bicep-teams-bot-001"]
  location         = "West Europe"
  date             = var.date
}
