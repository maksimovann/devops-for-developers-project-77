setup:
	terraform -chdir=terraform init

plan:
	terraform -chdir=terraform plan

apply:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

fmt:
	terraform -chdir=terraform fmt -recursive

validate:
	terraform -chdir=terraform validate
