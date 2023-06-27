# Terraform Hetzner Cloud Config

These Terraform scripts create three nodes in Hetzner Cloud, attach a private network to them and create three volumes for each node. Then it creates an Ansible inventory and a script to renew the SSH host entries.

## How to use it

Terraform has to be installed.

1. Clone repository
1. Change SSH key name in _main.tf_ (line with _ssh_keys_)  
   The key has to exist in the Hetzner Cloud instance
1. ```terraform init -upgrade```
1. ```export HCLOUD_TOKEN=<token>```
1. ```terraform plan -var hcloud_token=$HCLOUD_TOKEN```
1. ```terraform apply -var hcloud_token=$HCLOUD_TOKEN -auto-approve```
1. Use the inventory file 'inventory.yml' with Ansible
1. ```terraform destroy -var hcloud_token=$HCLOUD_TOKEN -auto-approve```

## Install RKE2

1. ansible-galaxy install lablabs.rke2
1. ansible-playbook -i inventory.yml rke2.yml