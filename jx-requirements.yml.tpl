cluster:
  provider: aks
  registry: ${registry_name}
%{ if key_vault_enabled || dns_enabled }
  azure:
%{ if key_vault_enabled }
    secretStorage:
      keyVaultName: ${key_vault_name}
%{ endif }
%{ if dns_enabled }
    dns:
      resourceGroup: ${dns_resource_group}
      tenantId: ${dns_tenant_id}
      subscriptionId: ${dns_subscription_id}
%{ endif }
%{ endif }
environments:
  - key: dev
ingress:
  domain: ${domain_name}
  tls: {}
%{ if key_vault_enabled }
secretStorage: azurekeyvault
%{ else }
secretStorage: vault
%{ endif }
