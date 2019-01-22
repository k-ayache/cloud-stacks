## Usage
Create terraform.tfvars, it would looks like:
```
$ cat terraform.tfvars
```

```
auth_url = "https://XXXX"
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

#To make it easy, keys would be the same and created before in the 2 tenants (terraform will not create them if dont exists)
key_pair_project_A = "XXXXXX"
key_pair_project_B = "XXXXXX"
```
Create stack:
```
$ terraform init
$ terraform apply -parallelism=1
```

Copy private key into bastion to be able to ssh backend from bastion

```
add "ForwardAgent yes" in ssh config 
$ssh-add ~/path/XXXXXX
```

We can generate hosts file to be used by ansible to play playbook on it using terraform-inventory:

```
$ terraform-inventory -u <SSH_USER_bastion> -k <SSH_PRIVATE_KEY>
```

Modify/Check generated file to be like this:

```
[bastion]
bastion_server_A ansible_host=xx.xx.63.182 ansible_user=cloud ansible_ssh_private_key_file=/home/karima/path/XXXXX ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
bastion_server_B ansible_host=xx.xx.63.186 ansible_user=cloud ansible_ssh_private_key_file=/home/karima/path/XXXXX ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
[project_A]
backend_server_A ansible_host=192.168.20.3 ansible_user=cloud ansible_ssh_private_key_file=/home/karima/path/XXXXX ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -i /home/karima/path/XXXXX cloud@xx.xx.63.182"'
[project_B]
backend_server_B ansible_host=192.168.30.3 ansible_user=cloud ansible_ssh_private_key_file=/home/karima/path/XXXXX ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -i /home/karima/path/XXXXX cloud@xx.xx.63.186"'
```
Start the playbook that will start tmux in backends and play ping between them:
```
$ansible-playbook -i hosts playbook.yml
```

SSH to bastion from it ssh to his backend and attach to the opened tmux session by ansible:
```
$ssh USER@BASTION_ADRESS
$ssh USER@BACKEND_ADRESS
$ tmux a
```
Create route-target between tenants by starting the script setup_inter_tenant_x-x.yml in bstcld (sudo password is asked):
there are 2 files: setup_inter_tenant_2-21.yml for contrail-2.21 and setup_inter_tenant_3-2.yml for contrail-3.2
```
$ ansible-playbook -K -i <bstcld-adress> , setup_inter_tenant_3-2.yml
```
Check the ping in tmux you'll see the succes ping between tenants VMs
