################################################################
#
# Author: 	Mark Higginbottom
#
# Date:		27/09/2016
#
#Vagrant PROJECT file to create multiple VMs for Ansible training 
#
#
#################################################################
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

 
Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  
  ##control VM
  config.vm.define "control" do |control|
    control.vm.box = "bento/centos-7.2"
    control.vm.hostname = 'control'

    control.vm.network :private_network, ip: "192.168.100.101"
    control.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"


    control.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "control"]
    end

	#map shared directory
	control.vm.synced_folder "shared", "/home/vagrant/shared"

	control.vm.provision "shell", inline: <<-SHELL
		#set ownership of shared directory to vagrant
		sudo chown -R vagrant:vagrant /home/vagrant/shared
		##Install Ansible on Control node
		#sudo apt-get update -y
		sudo yum install vim -y
		sudo yum install epel-release -y
		sudo yum install ansible -y	
		##Install Git
		sudo yum install git -y
		##Turn off ansible key checking
		export ANSIBLE_HOST_KEY_CHECKING=false
	SHELL

	##run ssh-key setup script
    control.vm.provision "info", type: "shell", path: "scripts/ssh-keys.sh"  
	##run info script
    control.vm.provision "info", type: "shell", path: "scripts/vminfo.sh"  

  end

  ##victim VM
  config.vm.define "victim" do |victim|
    victim.vm.box = "bento/centos-7.2"
    victim.vm.hostname = 'victim'

    victim.vm.network :private_network, ip: "192.168.100.102"
    victim.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"

    victim.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "victim"]
    end

	##run ssh-key setup script
    victim.vm.provision "info", type: "shell", path: "scripts/ssh-keys.sh"  
	##run info script
    victim.vm.provision "info", type: "shell", path: "scripts/vminfo.sh"  

  end
  
  ##tower VM
  config.vm.define "tower" do |tower|
    tower.vm.box = "ansible/tower"
    tower.vm.hostname = 'tower'

    tower.vm.network :private_network, ip: "192.168.100.103"
    tower.vm.network :forwarded_port, guest: 22, host: 10322, id: "ssh"

    tower.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      #v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--name", "tower"]
    end
	
	##map shared directory
	tower.vm.synced_folder "shared", "/home/vagrant/shared"
	tower.vm.provision "shell", inline: <<-SHELL
		#set ownership of shared directory to vagrant
		sudo chown -R vagrant:vagrant /home/vagrant/shared
	SHELL

	##run info script
	tower.vm.provision "info", type: "shell", path: "scripts/vminfo.sh"  
  
  end

end
