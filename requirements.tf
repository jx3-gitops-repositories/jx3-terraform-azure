locals {
  jx_requirerments_interpolated_content = templatefile("${path.module}/jx-requirements.yml.tpl", {

    registry_name        = "${module.registry.registry_name}.azurecr.io"
    domain_name          = module.dns.domain
    dns_enabled          = var.dns_enabled
    dns_resource_group   = module.dns.resource_group_name
    dns_tenant_id        = module.dns.tenant_id
    dns_subscription_id  = module.dns.subscription_id
    key_vault_enabled    = var.key_vault_enabled
    key_vault_name       = module.secrets.key_vault_name
    log_container_name   = module.storage.log_container_name
    storage_account_name = module.storage.storage_account_name
  })

  jx_requirements_split_content   = split("\n", local.jx_requirerments_interpolated_content)
  jx_requirements_compact_content = compact(local.jx_requirements_split_content)
  jx_requirements_content         = join("\n", local.jx_requirements_compact_content)
}


resource "kubernetes_config_map" "jenkins_x_requirements" {
  metadata {
    name      = "terraform-jx-requirements"
    namespace = "default"
  }
  data = {
    "jx-requirements.yml" = local.jx_requirements_content
  }

  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
  depends_on = [
    module.cluster
  ]
}
