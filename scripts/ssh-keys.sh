#set up ssh keys for vagrant user
sudo cp -rf /home/vagrant/shared/ssh-keys/.ssh /home/vagrant
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
sudo chmod 700 /home/vagrant/.ssh
sudo chmod 600 /home/vagrant/.ssh/id_rsa
