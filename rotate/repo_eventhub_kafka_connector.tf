module "eventhub_kafka_connector_github_repo_azure_connection" {
  source           = "./modules/github_repo_azure_connection"
  subscription_id  = data.azurerm_subscription.current.subscription_id
  tenant_id        = data.azuread_client_config.current.tenant_id
  repository       = "eventhub-kafka-connector"
  application_name = "eventhub-kafka-connector"
  resource_groups  = ["rg-eventhub-kafka-connector-001"]
  location         = "West Europe"
  date             = var.date
}
