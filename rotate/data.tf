data "azuread_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

data "azuread_service_principal" "graph" {
    # graph api application id
    application_id = "00000003-0000-0000-c000-000000000000"
}

data "azuread_service_principal" "azure_ad" {
    # azure ad application id
    application_id = "00000002-0000-0000-c000-000000000000"
}

locals {
    graph = {
        application_id = data.azuread_service_principal.graph.application_id
        app_roles = {for app_role in data.azuread_service_principal.graph.app_roles : app_role.value => app_role.id }
        oauth2_permissions = {for oauth2_permission in data.azuread_service_principal.graph.oauth2_permissions : oauth2_permission.value => oauth2_permission.id }
    }
    azure_ad = {
        application_id = data.azuread_service_principal.azure_ad.application_id
        app_roles = {for app_role in data.azuread_service_principal.azure_ad.app_roles : app_role.value => app_role.id }
        oauth2_permissions = {for oauth2_permission in data.azuread_service_principal.azure_ad.oauth2_permissions : oauth2_permission.value => oauth2_permission.id }
    }
}
