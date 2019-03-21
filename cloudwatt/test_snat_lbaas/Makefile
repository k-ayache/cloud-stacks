# Create a RC file (cloud_stack.rc) and edit it like the following:
# export SSH_USER=user
# export SSH_KEY=/home/user/.ssh/ssh_key
# export INVENTORY=hosts
# export COLORTERM=gnome-terminal

switch:
	terraform workspace select $$OS_REGION_NAME

init: switch
	terraform init

apply: switch
	terraform apply -parallelism=1 -var-file=$$OS_REGION_NAME.tfvars -auto-approve

inventory: switch
	. ./cloud_stack.rc; \
	terraform-inventory -b $$(cat terraform.tfstate.d/$$OS_REGION_NAME/terraform.tfstate | jq -r .modules[0].outputs.bastion_fip.value[0]) -u $$SSH_USER -k $$SSH_KEY -o $$INVENTORY; \
	sed -i 's/bastion_snat/bastion/g; s/backend_snat/backend/g' hosts

destroy: switch
	terraform destroy -parallelism=1 -var-file=$$OS_REGION_NAME.tfvars -force

check:
	. ./cloud_stack.rc; \
	ansible -i $$INVENTORY -m ping all

configure:
	. ./cloud_stack.rc; \
	ansible-playbook -i $$INVENTORY playbook.yml

connect:
	. ./cloud_stack.rc; \
	bastion_ip=$$(cat terraform.tfstate.d/$$(terraform workspace show)/terraform.tfstate | jq -r .modules[0].outputs.bastion_fip.value[0]); \
	echo "SSH : connecting to ... $$bastion_ip "; \
	$$($$COLORTERM -e "ssh -i $$SSH_KEY $$SSH_USER@$$bastion_ip -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"); \
	for i in $$(cat terraform.tfstate.d/$$(terraform workspace show)/terraform.tfstate | jq -r '.modules[0].outputs.backend_ip.value | .[]'); do \
	  echo "SSH : connecting to ... $$i "; \
	  $$($$COLORTERM -e "ssh -i $$SSH_KEY $$SSH_USER@$$i -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -i $$SSH_KEY $$SSH_USER@$$bastion_ip\""); \
	done

tmux-connect:
	. ./cloud_stack.rc; \
	bastion_ip=$$(cat terraform.tfstate.d/$$(terraform workspace show)/terraform.tfstate | jq -r .modules[0].outputs.bastion_fip.value[0]); \
	echo "SSH : connecting to ... $$bastion_ip "; \
	$$($$COLORTERM -e "ssh -i $$SSH_KEY $$SSH_USER@$$bastion_ip -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t 'tmux a'" ); \
	for i in $$(cat terraform.tfstate.d/$$(terraform workspace show)/terraform.tfstate | jq -r '.modules[0].outputs.backend_ip.value | .[]'); do \
	  echo "SSH : connecting to ... $$i "; \
	  $$($$COLORTERM -e "ssh -i $$SSH_KEY $$SSH_USER@$$i -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -i $$SSH_KEY $$SSH_USER@$$bastion_ip\" -t 'tmux a'"); \
	done

disconnect:
	bastion_ip=$$(cat terraform.tfstate.d/$$(terraform workspace show)/terraform.tfstate | jq -r .modules[0].outputs.bastion_fip.value[0]); \
	echo "SSH : disconnecting from ... $$bastion_ip "; \
	for i in $$(cat terraform.tfstate.d/$$(terraform workspace show)/terraform.tfstate | jq -r '.modules[0].outputs.backend_ip.value | .[]'); do \
	  echo "SSH : disconnecting from ... $$i "; \
	done; \
	ps aux | grep "ssh -i" | grep $$bastion_ip | awk '{print $$2}' | xargs kill

reconnect: disconnect connect

tmux-reconnect: disconnect tmux-connect

