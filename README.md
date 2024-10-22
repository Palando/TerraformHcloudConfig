# Terraform Hetzner Cloud Config

These Terraform scripts create three nodes in Hetzner Cloud, attach a private network to them and create three volumes for each node. Then it creates an Ansible inventory and a script to renew the SSH host entries.

## How to use it

1. Clone repository
1. Change SSH key name in _main.tf_ (line with _ssh_keys_)  
   The key has to exist in the Hetzner Cloud instance
1. Select OS and TF/OT, for other combinations adjust:

### With Terraform on Linux/MacOS

Terraform has to be installed.

1. ```terraform init -upgrade```
1. ```export HCLOUD_TOKEN=<token>```
1. ```terraform plan -var hcloud_token=$HCLOUD_TOKEN```
1. ```terraform apply -var hcloud_token=$HCLOUD_TOKEN -auto-approve```
1. Use the inventory file 'inventory.yaml' with Ansible
1. ```terraform destroy -var hcloud_token=$HCLOUD_TOKEN -auto-approve```

### With OpenTofu on Windows

Within PowerShell

1. Install OpenTofu: ```winget install OpenTofu.Tofu```
1. ```tofu init -upgrade```
1. ```$Env:HCLOUD_TOKEN = "<token>"```
1. ```tofu plan -var hcloud_token=$Env:HCLOUD_TOKEN```
1. ```tofu apply -var hcloud_token=$Env:HCLOUD_TOKEN -auto-approve```
1. Use the inventory file 'inventory.yaml' with Ansible
1. ```tofu destroy -var hcloud_token=$Env:HCLOUD_TOKEN -auto-approve```

## Install RKE2

1. ansible-galaxy install lablabs.rke2
1. ansible-playbook -i inventory.yaml rke2.yml
