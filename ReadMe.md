Ansible-Test
============

This is a Vagrant environment for testing/learning about Ansible when you are handicapped by having a Windows machine. ;0)

The Vagrant script will spin up 3 CentOS machines on a private network:

* control (192.168.100.101) - Ansible control machine
* victim  (192.168.100.102) - guinea-pig machine inflict all your Ansible experiments on.
* tower   (192.168.100.103) - Ansible Tower machine that provides a GUI for Ansible.


Pre-requisites
--------------

* Virtual Box
* Cygwin
* Vagrant
* Vagrant plugin vagrant-vbguest

The Vagrantfile will spin up the VMs and install Ansible, ssh-keys etc. Script examples can be found in the **shared** directory.

```
vagrant up --no-parallel
vagrant ssh control
```

Ansible your head off.


Enjoy!
