module "aws_kafka_cosmosdb_connect_github_repo_azure_connection" {
  source           = "./modules/github_repo_azure_connection"
  subscription_id  = data.azurerm_subscription.current.subscription_id
  tenant_id        = data.azuread_client_config.current.tenant_id
  repository       = "aws-kafka-cosmosdb-connect"
  application_name = "aws-kafka-cosmosdb-connect"
  resource_groups  = ["rg-aws-kafka-cosmosdb-connect-001"]
  location         = "West Europe"
  date             = var.date
}
