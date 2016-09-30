#set up ssh keys for vagrant user
cp /home/vagrant/shared/ssh-keys/.ssh /home/vagrant
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/id_rsa
