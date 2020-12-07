locals {
  jx_requirerments_interpolated_content = templatefile("${path.module}/jx-requirements.yml.tpl", {

    registry_name = "${module.registry.registry_name}.azurecr.io"

  })

  jx_requirerments_split_content   = split("\n", local.jx_requirerments_interpolated_content)
  jx_requirerments_compact_content = compact(local.jx_requirerments_split_content)
  jx_requirerments_content         = join("\n", local.jx_requirerments_compact_content)
}


resource "kubernetes_config_map" "jenkins_x_requirements" {
  metadata {
    name      = "terraform-jx-requirements"
    namespace = "default"
  }
  data = {
    "jx-requirements.yml" = local.jx_requirerments_content
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
