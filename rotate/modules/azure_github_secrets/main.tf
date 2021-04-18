variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "repository" {
  type = string
}

variable "application_id" {
  type = string
}

variable "application_object_id" {
  type = string
}

variable "date" {
  type = string
}

locals {
  date        = tonumber(var.date)
  odd_keeper  = floor((local.date + 1) / 2)
  even_keeper = floor(local.date / 2)
  use_even    = local.date % 2 == 0
}

resource "random_uuid" "odd" {
}

resource "azuread_application_password" "odd" {
  application_object_id = var.application_object_id
  description           = "odd"
  value                 = random_password.odd.result
  end_date_relative     = "1440h"
  key_id                = random_uuid.odd.result
}

resource "random_password" "odd" {
  keepers = {
    "date" = local.odd_keeper
  }
  length  = 36
  special = false
}

resource "random_uuid" "even" {
}

resource "azuread_application_password" "even" {
  application_object_id = var.application_object_id
  description           = "even"
  value                 = random_password.even.result
  end_date_relative     = "1440h"
  key_id                = random_uuid.even.result
}

resource "random_password" "even" {
  keepers = {
    "date" = local.even_keeper
  }
  length  = 36
  special = false
}

resource "github_actions_secret" "terraform" {
  repository      = var.repository
  secret_name     = "AZURE_CREDENTIALS"
  plaintext_value = <<-EOT
{
  "clientId": "${var.application_id}",
  "clientSecret": "${local.use_even ? random_password.even.result : random_password.odd.result}",
  "subscriptionId": "${var.subscription_id}",
  "tenantId": "${var.tenant_id}",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
EOT
}

resource "github_actions_secret" "arm_client_id" {
  repository = var.repository
  secret_name = "ARM_CLIENT_ID"
  plaintext_value = var.application_id
}

resource "github_actions_secret" "arm_client_secret" {
  repository = var.repository
  secret_name = "ARM_CLIENT_SECRET"
  plaintext_value = local.use_even ? random_password.even.result : random_password.odd.result
}

resource "github_actions_secret" "arm_subscription_id" {
  repository = var.repository
  secret_name = "ARM_SUBSCRIPTION_ID"
  plaintext_value = var.subscription_id
}

resource "github_actions_secret" "arm_tenant_id" {
  repository = var.repository
  secret_name = "ARM_TENANT_ID"
  plaintext_value = var.tenant_id
}

output "secret" {
  value = github_actions_secret.terraform.plaintext_value
}
