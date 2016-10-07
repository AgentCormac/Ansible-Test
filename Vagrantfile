#################################################################
#
# Author: 	Mark Higginbottom
#
# Contributors: Jon Spriggs
#
# Date:		27/09/2016 - 07/10/2016
#
# Vagrant PROJECT file to create multiple VMs for Ansible training 
#
##################################################################
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder "shared", "/home/vagrant/shared"

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 512]
  end
  
  control.vm.provision "shell", inline: <<-SHELL
    #set ownership of shared directory to vagrant
    sudo chown -R vagrant:vagrant /home/vagrant/shared
  SHELL
  
  ##control VM
  config.vm.define "control" do |control|
    control.vm.hostname = 'control'

    control.vm.network :private_network, ip: "192.168.100.101"
    control.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"

    control.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--name", "control"]
    end
    
    control.vm.provision "shell", inline: <<-SHELL
      ##Install Ansible on Control node
      sudo yum install vim epel-release ansible yum-utils git -y
      ##Turn off ansible key checking
      export ANSIBLE_HOST_KEY_CHECKING=false
    SHELL
  end

  ##victim VM
  config.vm.define "victim" do |victim|
    victim.vm.hostname = 'victim'

    victim.vm.network :private_network, ip: "192.168.100.102"
    victim.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"

    victim.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--name", "victim"]
    end
  end
  
  ##tower VM
  config.vm.define "tower" do |tower|
    tower.vm.box = "ansible/tower"
    tower.vm.hostname = 'tower'

    tower.vm.network :private_network, ip: "192.168.100.103"
    tower.vm.network :forwarded_port, guest: 22, host: 10322, id: "ssh"

    tower.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "tower"]
    end
  end

  ##run info script
  config.vm.provision "info", type: "shell", path: "scripts/vminfo.sh"  
  ##run ssh-key setup script
  config.vm.provision "info", type: "shell", path: "scripts/ssh-keys.sh"  
end
