
1. tf-Dateien anlegen
2. ```terraform init```
2. ```export HCLOUD_TOKEN=<token>```
3. ```terraform plan -var hcloud_token=$HCLOUD_TOKEN -auto-approve```
3. ```terraform apply -var hcloud_token=$HCLOUD_TOKEN -auto-approve```
4. ...
5. ```terraform destroy -var hcloud_token=$HCLOUD_TOKEN -auto-approve```