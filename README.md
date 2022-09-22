# Terraform Hetzner Cloud Example

## How to use it

Terraform has to be installed.

1. Clone repository
1. Change SSH key name in _main.tf_ (line with _ssh_keys_)  
   The key has to exist in the Hetzner Cloud instance
1. Comment out _provisioner_ block  
   This is an example how to execute an Ansible playbook on the instance
1. ```terraform init```
1. ```export HCLOUD_TOKEN=<token>```
1. ```terraform plan -var hcloud_token=$HCLOUD_TOKEN```
1. ```terraform apply -var hcloud_token=$HCLOUD_TOKEN -auto-approve```
1. Do something with the VM
1. ```terraform destroy -var hcloud_token=$HCLOUD_TOKEN -auto-approve```
