resource "azurerm_resource_group" "this" {
  for_each = toset(var.resource_groups)
  name     = each.key
  location = var.location
}

resource "azuread_application" "this" {
  display_name = var.application_name
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}

resource "azurerm_role_assignment" "this" {
  for_each             = toset(var.resource_groups)
  scope                = azurerm_resource_group.this[each.key].id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.this.object_id
}

module "this_sp_secrets" {
  source                = "../azure_github_secrets"
  subscription_id       = var.subscription_id
  tenant_id             = var.tenant_id
  repository            = var.repository
  application_id        = azuread_application.this.application_id
  application_object_id = azuread_application.this.id
  date                  = var.date
}
