Test1
=====

This project installs Nginx on the victims VM(s).

Start the VMs from the Ansible-Test directory and ssh onto the control machine:
```
vagrant up --no-parallel
vagrant ssh control
cd shared/ansible/test1/
```

First test connectivity between all the VMs using
```
ansible all -m ping -i inventory
```
The results should look like:
```
control | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
victim | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
tower | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
We can then run the playbook **site.yml** to install the epl repo using a **role** from Ansible Galaxy and then Ngix, following standard conventions, not the out of the box Centos configuration.
```
ansible-playbook site-yml -i inventory
```
The results should look like:
```
PLAY [victims] *****************************************************************

TASK [setup] *******************************************************************
ok: [victim]

TASK [geerlingguy.repo-epel : Check if EPEL repo is already configured.] *******
ok: [victim]

TASK [geerlingguy.repo-epel : Install EPEL repo.] ******************************
skipping: [victim]

TASK [geerlingguy.repo-epel : Import EPEL GPG key.] ****************************
skipping: [victim]

PLAY [Configure webserver with nginx] ******************************************

TASK [setup] *******************************************************************
ok: [victim]

TASK [install nginx] ***********************************************************
ok: [victim]

TASK [Create sites-available directory] ****************************************
ok: [victim]

TASK [Create sites-enabled directory] ******************************************
ok: [victim]

TASK [copy nginx config file] **************************************************
ok: [victim]

TASK [copy nginx config file for default virtual server] ***********************
ok: [victim]

TASK [enable configuration] ****************************************************
ok: [victim]

TASK [copy index.html] *********************************************************
ok: [victim]

TASK [restart nginx] ***********************************************************
changed: [victim]

PLAY RECAP *********************************************************************
victim                     : ok=11   changed=1    unreachable=0    failed=0
```

## Interesting Points
### inventory
The inventory file (often called and named hosts by Ansible books - we (Fujitsu - [ Nick Cross and myself]) have decided to standardise on **inventory** to avoid confusion with the networking hosts file.

The inventory file contains a list of the system hosts names and their ips (if they are not DNS addressable). Each host can be assigned to a group:
```
[victims]
victim
```
In the above the **victim** machine is in the **victims** group.

The most important part of this file is that the ssh key and user id that Ansible must use to connect can be specified:
```
victim ansible_ssh_host=192.168.100.102 ansible_ssh_user=vagrant ansible_ssh_private_key_file=~/.ssh/id_rsa

```
Here we are secifiying the connection users as **vagrant** and are using the **private key** of the vagrant user. The vagrant user **public key** has already been pre-configured in the victim **authorized_keys** by the Vagrant provisioning process.

### roles
This script uses a predefined role from Ansible Galaxy to set up the epel repository on the victim so that Nginx can be installed. The role was installed into the role directory by:
```
ansible-galaxy install geerlingguy.repo-epel -p ./roles
```
The role is executed by **site.yml** by including the role:
```
roles:
  - geerlingguy.repo-epel
```
### nginx configuration
Nginx uses a convention of defining sites in /etc/nginx/sites-available. A symlink from sites-enabled enables a particular site configuration. This convention is not followed by the Centos ngix installation so we:
1. Install nginx
2. Create sites-available directory
3. Create sites-enabled directory
4. Copy our site config (default) to sites-available
5. symlink from sites-enabled to sites-available/default
6. Overwrite ngix.conf with our version that removes the default configured site and tells ngix to look in sites-enabled.
7. restart the nginx service.

Other than the above this example follow the first example as detailed in **"Ansible Up and running"**

## Notes
I am sure site.yml is not in the best format, I think the ngix installation script can be run as a role.
Also I would like to pass the target group or inventory in as variable. This would enable the script to be run against different environments e.g. dev, test, prod etc.
