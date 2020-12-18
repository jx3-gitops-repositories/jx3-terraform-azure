mkdir -p ~/.kube
terraform output kube_config_admin | sed -e 's/<<EOT/---/g' -e 's/EOT//g' > ~/.kube/config
