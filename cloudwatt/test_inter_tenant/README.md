## Usage
Create terraform.tfvars, it would looks like:
```
$ cat terraform.tfvars
```

```
auth_url = "XXX"
region = "XXX"

#credentials tenant A
name_project_A = "XXXXXX"
user_project_A = "XXXXXX"
pwd_project_A = "XXXXXX"

#credentials tenant B:
name_project_B = "XXXXXX"
user_project_B = "XXXXXX"
pwd_project_B = "XXXXXX"

image_name = "XXXXXX"
flavor_name = "XXXXXX"

#To make it easy, keys would be the same and created before in the 2 tenants
key_pair_project_A = "XXXXXX"
key_pair_project_B = "XXXXXX"
```
Create the stack:
```
$ terraform init
$ terraform apply -parallelism=1
```

We can generate hosts file to be used by ansible to play playbook on it using terraform-inventory:

```
$ terraform-inventory -u <SSH_USER_bastion> -k <SSH_PRIVATE_KEY>
```

Modify/Check generated file to look like:

```
[bastion]
bastion_server_A ansible_host=xx.xx.xx.182 ansible_user=cloud ansible_ssh_private_key_file=/path/private-key ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
bastion_server_B ansible_host=xx.xx.xx.186 ansible_user=cloud ansible_ssh_private_key_file=/path/private-key ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
[project_A]
backend_server_A ansible_host=192.168.20.3 ansible_user=cloud ansible_ssh_private_key_file=/path/private-key ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -i /path/private-key cloud@xx.xx.xx.182"'
[project_B]
backend_server_B ansible_host=192.168.30.3 ansible_user=cloud ansible_ssh_private_key_file=/path/private-key ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -i /path/private-key cloud@xx.xx.xx.186"'
```
Start the playbook that will start tmux in backends and play ping between them:
```
$ansible-playbook -i hosts playbook.yml
```

ssh to bastion, from and ssh to his backend and attach to the opened tmux session by ansible:
```
$ssh USER@bastion-ip
$ssh USER@backend-ip
$ tmux a
```
Create route-target between tenants by starting the script setup_inter_tenant_x-x.yml in bastion of the enviroment (sudo password is asked):
there are 2 files: setup_inter_tenant_2-21.yml for contrail-2.21 and setup_inter_tenant_3-2.yml for contrail-3.2

First, create the file ansible-vars.yml that seems like:

```
tenant_name: ""
user_name: ""
password: ""
server_ip: ""
auth_plugin: ""
auth_url: ""
```
Create the route-target:

```
$ ansible-playbook -K -i <bastion> , setup_inter_tenant_3-2.yml
```
Check the ping in tmux you'll see the succes ping between tenants VMs
