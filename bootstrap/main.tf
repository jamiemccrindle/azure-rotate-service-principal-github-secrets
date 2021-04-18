resource "azurerm_resource_group" "terraform_state" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

resource "github_actions_secret" "tfstate_resource_group_name" {
  repository = "azure-rotate-service-principal-github-secrets"
  secret_name = "TFSTATE_RESOURCE_GROUP_NAME"
  plaintext_value = var.resource_group_name
}

resource "github_actions_secret" "tfstate_storage_account_name" {
  repository = "azure-rotate-service-principal-github-secrets"
  secret_name = "TFSTATE_STORAGE_ACCOUNT_NAME"
  plaintext_value = var.storage_account_name
}

resource "github_actions_secret" "tfstate_container_name" {
  repository = "azure-rotate-service-principal-github-secrets"
  secret_name = "TFSTATE_CONTAINER_NAME"
  plaintext_value = var.container_name
}

resource "github_actions_secret" "tfstate_key" {
  repository = "azure-rotate-service-principal-github-secrets"
  secret_name = "TFSTATE_KEY"
  plaintext_value = var.key
}

resource "github_actions_secret" "org_github_token" {
  repository = "azure-rotate-service-principal-github-secrets"
  secret_name = "ORG_GITHUB_TOKEN"
  plaintext_value = var.org_github_token
}