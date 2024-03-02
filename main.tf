module "cluster" {
  source                               = "github.com/jenkins-x-terraform/terraform-jx-azure?ref=v0.7.5"
  apex_domain_integration_enabled      = var.apex_domain_integration_enabled
  apex_domain                          = var.apex_domain
  subdomain                            = var.subdomain
  apex_resource_group_name             = var.apex_resource_group_name
  dns_resource_group_name              = var.dns_resource_group_name
  cluster_name                         = var.cluster_name
  cluster_network_model                = var.cluster_network_model
  cluster_node_resource_group_name     = var.cluster_node_resource_group_name
  cluster_resource_group_name          = var.cluster_resource_group_name
  cluster_version                      = var.cluster_version
  enable_log_analytics                 = var.enable_log_analytics
  jx_bot_token                         = var.jx_bot_token
  jx_git_url                           = var.jx_git_url
  jx_bot_username                      = var.jx_bot_username
  server_side_apply_enabled            = var.server_side_apply_enabled
  key_vault_enabled                    = var.key_vault_enabled
  key_vault_name                       = var.key_vault_name
  key_vault_resource_group_name        = var.key_vault_resource_group_name
  key_vault_sku                        = var.key_vault_sku
  location                             = var.location
  logging_retention_days               = var.logging_retention_days
  network_name                         = var.network_name
  network_resource_group_name          = var.network_resource_group_name
  node_size                            = var.node_size
  node_count                           = var.node_count
  min_node_count                       = var.min_node_count
  max_node_count                       = var.max_node_count
  use_spot                             = var.use_spot
  spot_max_price                       = var.spot_max_price
  build_node_size                      = var.build_node_size
  build_node_count                     = var.build_node_count
  min_build_node_count                 = var.min_build_node_count
  max_build_node_count                 = var.max_build_node_count
  storage_resource_group_name          = var.storage_resource_group_name
  subnet_cidr                          = var.subnet_cidr
  subnet_name                          = var.subnet_name
  vnet_cidr                            = var.vnet_cidr
  registry_resource_group_name         = var.registry_resource_group_name
  use_existing_acr_name                = var.use_existing_acr_name
  use_existing_acr_resource_group_name = var.use_existing_acr_resource_group_name
}

output "connect" {
  description = "Connect to cluster"
  value       = module.cluster.connect
}
output "follow_install_logs" {
  description = "Follow Jenkins X install logs"
  value       = "jx admin log"
}
output "docs" {
  description = "Follow Jenkins X 3.x docs for more information"
  value       = "https://jenkins-x.io/v3/"
}
output "kube_config_admin" {
  value     = module.cluster.kube_config_admin
  sensitive = true
}
