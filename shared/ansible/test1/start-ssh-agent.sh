#!/bin/bash          
echo Start ssh-agent  
eval $(ssh-agent)
ssh-add /home/vagrant/.ssh/id_rsa
ansible  all -m ping -i hosts