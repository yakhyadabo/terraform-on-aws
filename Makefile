default: format

DEV=env-dev

format: 
	@terraform fmt


#### VPC ####

vpc-init: 
	@cd ${DEV}/vpc && terraform init

vpc-plan: 
	@cd ${DEV}/vpc && terraform plan 

vpc-create: 
	@cd ${DEV}/vpc && @terraform apply

vpc-destroy: 
	@cd ${DEV}/vpc && terraform destroy


### Services

services-init: 
	@cd ${DEV}/services && terraform init

services-plan: 
	@cd ${DEV}/services && terraform plan 

services-create: 
	@cd ${DEV}/services && @terraform apply

services-destroy: 
	@cd ${DEV}/services && terraform destroy


### DNS 

dns-init: 
	@cd env-shared/dns && terraform init

dns-plan: 
	@cd env-shared/dns && terraform plan 

dns-create: 
	@cd env-shared/dns && @terraform apply

dns-destroy: 
	@cd env-shared/dns && terraform destroy
