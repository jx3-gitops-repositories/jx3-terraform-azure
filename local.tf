resource "random_pet" "name" {
}

data "azurerm_subscription" "current" {
}

locals {
  cluster_name = var.cluster_name != "" ? var.cluster_name : replace(random_pet.name.id, "-", "")

  registry_secrets = {
    jx-dev-registry-username : module.registry.admin_username,
    jx-dev-registry-password : module.registry.admin_password,
  }

  merged_secrets = merge(local.registry_secrets)
}
