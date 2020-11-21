# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.20.0"
  features {}
  subscription_id = "d803dacf-38f0-461b-9a37-084f0ea2824a"
  client_id       = "62d7a32d-d20c-4d54-a85f-0060119798d3"
  client_secret   = var.azure_password
  tenant_id       = "ecf620ff-452b-498d-80a3-7724532966ca"
}
