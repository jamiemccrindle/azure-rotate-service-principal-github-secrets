terraform {
  backend "azurerm" {
  }
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}
