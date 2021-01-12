apiVersion: core.jenkins-x.io/v4beta1
kind: Requirements
spec:
  cluster:
    provider: aks
    registry: ${registry_name}
    chartRepository: ${registry_name}
    chartOCI: true
    azure:
      storage:
        storageAccountName: ${storage_account_name}
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
  environments:
    - key: dev
  ingress:
    domain: ${domain_name}
  %{ if dns_enabled }
    externalDNS: true
  %{ endif }
    tls: {}
  %{ if key_vault_enabled }
  secretStorage: azurekeyvault
  %{ else }
  secretStorage: vault
  %{ endif }
  storage:
    - name: logs
      url: azblob://${log_container_name}
  
