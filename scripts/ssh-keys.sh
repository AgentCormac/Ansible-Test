#! /bin/bash

#set up ssh keys for vagrant user
if [ ! -e "/home/vagrant/shared/ssh-keys/.ssh/`hostname`.pub" ]; then
  ssh-keygen -f "/home/vagrant/shared/ssh-keys/.ssh/`hostname`" -C "Key for `hostname`" -P ""
fi
cat /home/vagrant/shared/ssh-keys/.ssh/control.pub >> /home/vagrant/.ssh/authorized_keys
sudo cp -rf /home/vagrant/shared/ssh-keys/.ssh/* /home/vagrant/.ssh/
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
sudo chmod 700 /home/vagrant/.ssh
sudo chmod 600 /home/vagrant/.ssh/*
echo .
echo These are the ssh keys to access this VM.
echo There should be the vagrant public key and the control public key.
cat /home/vagrant/.ssh/authorized_keys
