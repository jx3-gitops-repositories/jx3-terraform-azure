cluster:
  provider: aks
  registry: "${registry_name}"
%{ if key_vault_enabled }
  azure:
    secretStorage:
      keyVaultName: "${key_vault_name}"
%{ endif }
environments:
  - key: dev
ingress:
  domain: "${domain_name}"
  tls: {}
%{ if key_vault_enabled }
secretStorage: azurekeyvault
%{ else }
secretStorage: vault
%{ endif }
