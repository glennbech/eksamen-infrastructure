#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry
resource "azurerm_resource_group" "rg" {
  name     = "ExamResourceGroup"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                     = "examContainerRegistry"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  georeplication_locations = ["West Europe"]
}