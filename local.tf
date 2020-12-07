resource "random_pet" "name" {
}

data "azurerm_subscription" "current" {
}

locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : replace(random_pet.name.id, "-", "")
  subscription_id = var.subscription_id != "" ? var.subscription_id : data.azurerm_subscription.current.subscription_id
}
