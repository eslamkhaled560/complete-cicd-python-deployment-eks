#!/bin/bash

######################################################################################################################
### Before executing this script, you should configure "inventory.txt", Ansible and Terraform with your own values ###
######################################################################################################################

# Create infrastructure
terraform apply --auto-approve

# Use Jenkins public IP in the inventory file
ip=$(cat jenkins-pub-ip.txt)
sed -i "s/jenkins_pub_ip/$ip/g" inventory.txt

# Wait to update inventory file
sleep 15

# Skip ansible SSH authenticity checking
export ANSIBLE_HOST_KEY_CHECKING=flase
sleep 10

# Run ansible
ansible-playbook -i inventory.txt playbook.yml

# Return inventory to initial state for future use
sed -i "s/$ip/jenkins_pub_ip/g" inventory.txt
