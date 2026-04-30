terraform-setup:
	terraform -chdir=terraform init

terraform-plan:
	terraform -chdir=terraform plan

terraform-apply:
	terraform -chdir=terraform apply

terraform-destroy:
	terraform -chdir=terraform destroy

terraform-fmt:
	terraform -chdir=terraform fmt -recursive

terraform-validate:
	terraform -chdir=terraform validate

ansible-setup:
	ansible-galaxy install -r ansible/requirements.yml

prepare:
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags prepare

deploy:
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags deploy
