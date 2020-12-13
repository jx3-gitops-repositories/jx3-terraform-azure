resource "random_pet" "name" {
}

data "azurerm_subscription" "current" {
}

locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : replace(random_pet.name.id, "-", "")
}
