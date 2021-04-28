resource "azuread_application" "terraform" {
  display_name = "terraform"
  required_resource_access {
    resource_app_id = local.azure_ad.application_id
    resource_access {
      id   = local.azure_ad.app_roles["Application.ReadWrite.All"]
      type = "Role"
    }
    resource_access {
      id   = local.azure_ad.app_roles["Directory.ReadWrite.All"]
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "terraform" {
  application_id = azuread_application.terraform.application_id
}

resource "azurerm_role_assignment" "owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.terraform.object_id
}

module "terraform_sp_secrets" {
  source                = "./modules/azure_github_secrets"
  subscription_id       = data.azurerm_subscription.current.subscription_id
  tenant_id             = data.azuread_client_config.current.tenant_id
  repository            = "azure-rotate-service-principal-github-secrets"
  application_id        = azuread_application.terraform.application_id
  application_object_id = azuread_application.terraform.id
  date                  = var.date
}
