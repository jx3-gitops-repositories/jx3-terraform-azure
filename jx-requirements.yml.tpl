cluster:
  provider: aks
  registry: "${registry_name}"
environments:
  - key: dev
ingress:
  domain: "${domain_name}"
  tls: {}
secretStorage: vault
