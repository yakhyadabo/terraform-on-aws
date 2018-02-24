default: format

format: 
	@terraform fmt

### VPC

vpc-init: 
	@cd env-dev/vpc && terraform init

vpc-plan: 
	@cd env-dev/vpc && terraform plan 

vpc-create: 
	@cd env-dev/vpc && @terraform apply

vpc-destroy: 
	@cd env-dev/vpc && terraform destroy

### Services

services-init: 
	@cd env-dev/services && terraform init

services-plan: 
	@cd env-dev/services && terraform plan 

services-create: 
	@cd env-dev/services && @terraform apply

services-destroy: 
	@cd env-dev/services && terraform destroy


### DNS 

dns-init: 
	@cd env-shared/dns && terraform init

dns-plan: 
	@cd env-shared/dns && terraform plan 

dns-create: 
	@cd env-shared/dns && @terraform apply

dns-destroy: 
	@cd env-shared/dns && terraform destroy

