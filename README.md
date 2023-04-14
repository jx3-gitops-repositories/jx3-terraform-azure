# Azure Terraform Quickstart template

Use this template to easily create a new Git Repository for managing Jenkins X cloud infrastructure needs.

We recommend using Terraform to manange the infrastructure needed to run Jenkins X.  There are a number of cloud resources which may need to be created such as:

- Kubernetes cluster
- Storage buckets for long term storage of logs
- IAM Bindings to manage permissions for applications using cloud resources

Jenkins X likes to use GitOps to manage the lifecycle of both infrastructure and cluster resources.  This requires two Git Repositories to achieve this:
- **Infrastructure git repository**: infrastructure resources will be managed by Terraform and will keep resources in sync.
- **Cluster git repository**: the Kubernetes specific cluster resources will be managed by Jenkins X and keep resources in sync.

# Prerequisites

- A Git organisation that will be used to create the GitOps repositories used for Jenkins X below.
  e.g. https://github.com/organizations/plan.
- Create a git bot user (different from your own personal user)
  e.g. https://github.com/join
  and generate a personal access token, this will be used by Jenkins X to interact with git repositories.
  e.g. https://github.com/settings/tokens/new?scopes=repo,read:user,read:org,user:email,write:repo_hook,delete_repo,admin:repo_hook

- __This bot user needs to have write permission to write to any git repository used by Jenkins X.  This can be done by adding the bot user to the git organisation level or individual repositories as a collaborator__
  Add the new `bot` user to your Git Organisation, for now give it Owner permissions, we will reduce this to member permissions soon.
- Install `terraform` CLI - [see here](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform)
- Install `jx` CLI - [see here](https://github.com/jenkins-x/jx-cli/releases)
- An Azure account, with the required tools as described in this [guide](https://jenkins-x.io/v3/admin/platforms/azure/svc_principal/) 

# Git repositories

We use 2 git repositories:

* **Infrastructure** git repository for the Terraform configuration to setup/upgrade/modify your cloud infrastructure (kubernetes cluster, IAM accounts, IAM roles, buckets etc)
* **Cluster** git repository to contain the `helmfile.yaml` file to define the helm charts to deploy in your cluster

We use separate git repositories since the infrastructure tends to change rarely; whereas the cluster git repository changes a lot (every time you add a new quickstart, import a project, release a project etc).

Often different teams look after infrastructure; or you may use tools like Terraform Cloud to process changes to infrastructure & review changes to infrastructure more closely than promotion of applications.

# Getting started

__Note: remember to create the Git repositories below in your Git Organisation rather than your personal Git account else this will lead to issues with ChatOps and automated registering of webhooks__.

1. Create and clone your **Infrastructure** git repo from this GitHub Template https://github.com/jx3-gitops-repositories/jx3-terraform-azure/generate

    Note: Ensure **Owner** is the name of the Git Organisation that will hold the GitOps repositories used for Jenkins X.

2. Create a **Cluster** git repository; choosing your desired secrets store, either Vault or Azure Key Vault:
    - __Vault__: https://github.com/jx3-gitops-repositories/jx3-azure-vault/generate

    - __Azure Key Vault__: https://github.com/jx3-gitops-repositories/jx3-azure-akv/generate
    
    Note: Ensure **Owner** is the name of the Git Organisation that will hold the GitOps repositories used for Jenkins X.

3. You need to configure the git URL of your **Cluster** git repository (which contains `helmfile.yaml`) into the **Infrastructure** git repository (which contains `main.tf`). 

So from inside a git clone of the **Infrastructure** git repository (which already has the file `main.tf` inside) you need to link to the other **Cluster** repository (which contains `helmfile.yaml`) by committing the required terraform values from below. 

The contents of your `values.auto.tfvars` file should look something like this ....

```terraform
jx_git_url = "https://github.com/myowner/myname-cluster"
jx_bot_username = "bot_user"
```

4. commit and push any changes to your **Infrastructure** git repository:

```sh
git commit -a -m "fix: configure cluster repository and project"
git push
```

5. Now define an environment variable to pass the token into Terraform:

```sh
export TF_VAR_jx_bot_token=my-bot-token
```

6. Now, initialise, plan and apply Terraform:

```sh
terraform init
```

```sh
terraform plan
```

```sh
terraform apply
```

Connect to the cluster
```
$(terraform output connect)
```
Tail the Jenkins X installation logs
```
$(terraform output follow_install_logs)
```
Once finished you can now move into the Jenkins X Developer namespace

```sh
jx ns jx
```

and create or import your applications

```sh
jx project
```

## Terraform Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apex_domain"></a> [apex\_domain](#input\_apex\_domain) | The name of the parent/apex domain in which to create this domain zone, e.g. jenkins-x.io. Required if dns\_enabled set to true | `string` | `""` | no |
| <a name="input_apex_domain_integration_enabled"></a> [apex\_domain\_integration\_enabled](#input\_apex\_domain\_integration\_enabled) | Flag that when set attempts to create delegation records in apex domain to point to domain created by this module | `bool` | `false` | no |
| <a name="input_apex_resource_group_name"></a> [apex\_resource\_group\_name](#input\_apex\_resource\_group\_name) | The resource group in which the Azure DNS apex domain resides. Required if apex\_domain\_integration\_enabled is true | `string` | `""` | no |
| <a name="input_build_node_count"></a> [build\_node\_count](#input\_build\_node\_count) | The number of build nodes to use for the cluster | `number` | `null` | no |
| <a name="input_build_node_size"></a> [build\_node\_size](#input\_build\_node\_size) | The size of the build node to use for the cluster | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Variable to provide your desired name for the cluster. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_cluster_network_model"></a> [cluster\_network\_model](#input\_cluster\_network\_model) | Variable to define the network model for the cluster. Valid values are either `kubenet` or `azure` | `string` | `"kubenet"` | no |
| <a name="input_cluster_node_resource_group_name"></a> [cluster\_node\_resource\_group\_name](#input\_cluster\_node\_resource\_group\_name) | Resource group name in which to provision AKS cluster nodes. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | The name of the resource group in to which to provision AKS managed cluster. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version to use for the AKS cluster | `string` | `"1.20.7"` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | DNS prefix for the cluster. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_dns_resource_group_name"></a> [dns\_resource\_group\_name](#input\_dns\_resource\_group\_name) | Resource group in which to create the Azure DNS zone. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_enable_log_analytics"></a> [enable\_log\_analytics](#input\_enable\_log\_analytics) | Flag to indicate whether to enable Log Analytics integration for cluster | `bool` | `false` | no |
| <a name="input_jx_bot_token"></a> [jx\_bot\_token](#input\_jx\_bot\_token) | Bot token used to interact with the Jenkins X cluster git repository | `string` | n/a | yes |
| <a name="input_jx_bot_username"></a> [jx\_bot\_username](#input\_jx\_bot\_username) | Bot username used to interact with the Jenkins X cluster git repository | `string` | n/a | yes |
| <a name="input_jx_git_url"></a> [jx\_git\_url](#input\_jx\_git\_url) | URL for the Jenkins X cluster git repository | `string` | n/a | yes |
| <a name="input_key_vault_enabled"></a> [key\_vault\_enabled](#input\_key\_vault\_enabled) | Flag to indicate whether to provision Azure Key Vault for secret storage | `string` | `true` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of Azure Key Vault to create | `string` | `""` | no |
| <a name="input_key_vault_resource_group_name"></a> [key\_vault\_resource\_group\_name](#input\_key\_vault\_resource\_group\_name) | Resource group to create in which to place key vault | `string` | `""` | no |
| <a name="input_key_vault_sku"></a> [key\_vault\_sku](#input\_key\_vault\_sku) | SKU of the Key Vault resource to create. Valid values are standard or premium | `string` | `"standard"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region in to which to provision the cluster | `string` | `"australiaeast"` | no |
| <a name="input_logging_retention_days"></a> [logging\_retention\_days](#input\_logging\_retention\_days) | Number of days to retain logs in Log Analytics if enabled | `number` | `30` | no |
| <a name="input_max_build_node_count"></a> [max\_build\_node\_count](#input\_max\_build\_node\_count) | The maximum number of builder nodes to use for the cluster if autoscaling is enabled | `number` | `null` | no |
| <a name="input_max_node_count"></a> [max\_node\_count](#input\_max\_node\_count) | The maximum number of worker nodes to use for the cluster if autoscaling is enabled | `number` | `null` | no |
| <a name="input_min_build_node_count"></a> [min\_build\_node\_count](#input\_min\_build\_node\_count) | The minimum number of builder nodes to use for the cluster if autoscaling is enabled | `number` | `null` | no |
| <a name="input_min_node_count"></a> [min\_node\_count](#input\_min\_node\_count) | The minimum number of worker nodes to use for the cluster if autoscaling is enabled | `number` | `null` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the Virtual Network in Azure to be created. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | The name of the resource group in to which to provision network resources. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | The number of worker nodes to use for the cluster | `number` | `2` | no |
| <a name="input_node_size"></a> [node\_size](#input\_node\_size) | The size of the worker node to use for the cluster | `string` | `"Standard_B2ms"` | no |
| <a name="input_registry_resource_group_name"></a> [registry\_resource\_group\_name](#input\_registry\_resource\_group\_name) | The name of the resource group in to which to provision ACR managed registry. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_server_side_apply_enabled"></a> [server\_side\_apply\_enabled](#input\_server\_side\_apply\_enabled) | BETA: Flag to indicate to the jx-git-operator that you would like to use server side apply | `bool` | `false` | no |
| <a name="input_spot_max_price"></a> [spot\_max\_price](#input\_spot\_max\_price) | The maximum price you're willing to pay in USD per virtual machine, -1 to go to the maximum price | `number` | `-1` | no |
| <a name="input_storage_resource_group_name"></a> [storage\_resource\_group\_name](#input\_storage\_resource\_group\_name) | Resource group to create in which to place storage accounts | `string` | `""` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain name of the zone to create, e.g. dev-subdomain. | `string` | `""` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR of the provisioned  subnet within the `vnet_cidr` to to which worker nodes are placed | `string` | `"10.8.0.0/24"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet in Azure to be created. The script will create a random name if this is empty | `string` | `""` | no |
| <a name="input_use_existing_acr_name"></a> [use\_existing\_acr\_name](#input\_use\_existing\_acr\_name) | Name of the existing ACR that you would like to use, e.g. use this in multicluster setup, when you want to use DEV cluster ACR. | `string` | `null` | no |
| <a name="input_use_existing_acr_resource_group_name"></a> [use\_existing\_acr\_resource\_group\_name](#input\_use\_existing\_acr\_resource\_group\_name) | Name of the resources group of the existing ACR that you would like to use, e.g. use this in multicluster setup, when you want to use DEV cluster ACR. | `string` | `null` | no |
| <a name="input_use_spot"></a> [use\_spot](#input\_use\_spot) | Should we use spot instances for the build nodes | `bool` | `true` | no |
| <a name="input_vnet_cidr"></a> [vnet\_cidr](#input\_vnet\_cidr) | The CIDR of the provisioned Virtual Network in Azure in to which worker nodes are placed | `string` | `"10.8.0.0/16"` | no |

# Cleanup

To remove any cloud resources created here run:
```sh
terraform destroy
```

# Contributing

When adding new variables please regenerate the markdown table 
```sh
terraform-docs markdown table .
```
and replace the Inputs section above

## Formatting

When developing please remember to format codebase before raising a pull request
```sh
terraform fmt -check -diff -recursive
```
