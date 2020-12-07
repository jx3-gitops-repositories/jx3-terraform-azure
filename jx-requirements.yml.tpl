cluster:
  provider: aks
  registry: "${registry_name}"
environments:
  - key: dev
ingress:
  tls: {}
secretStorage: vault
