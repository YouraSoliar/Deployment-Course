#!/bin/bash

# if there are changes to app - run next commnds
# docker-compose build
# docker-compose push
#### 



source ./vars.sh  # load secterts to local terminal env vars

terraform init && terraform plan && terraform apply

# test if all ok
# -e is --extra-vars

terraform output -raw private_ssh_key > id_rsa

chmod 700 id_rsa

ansible -i servers -m ping all -e "$(terraform output | sed s/[\"\ ]//g)"

ansible-playbook -i servers playbook.yml -e "$(terraform output | sed s/[\"\ ]//g)"
ansible-playbook -i servers playbookbalancer.yml -e "$(terraform output | sed s/[\"\ ]//g)"
ansible-playbook -i servers playbookredis.yml -e "$(terraform output | sed s/[\"\ ]//g)"

echo "Done! Open the ip below in browser:"
terraform output public_ip_address_balancer

# terraform destroy

# ssh adminuser@20.124.98.161

# sudo docker pull -a  yourasoliar/embedded

python3 tracker.py  $(terraform output -raw public_ip_server_1):5000 \
                    $(terraform output -raw public_ip_address_balancer):80 \
                    --interval 10

