default: format

format: 
	@terraform fmt
	
vpc-init: 
	@cd env-dev/vpc && terraform init

vpc-plan: 
	@cd env-dev/vpc && terraform plan 

vpc-create: 
	@cd env-dev/vpc && @terraform apply

vpc-destroy: 
	@pushd env-dev/vpc && terraform destroy

services-init: 
	@cd env-dev/services && terraform init

services-plan: 
	@cd env-dev/services && terraform plan 

services-create: 
	@cd env-dev/services && @terraform apply

services-destroy: 
	@pushd env-dev/services && terraform destroy

## init: 
## 	@terraform init \
##  		-backend-config="bucket=terraform-remote-state-zeta" \
##  		-backend-config="key=dev/vpc.tfstate" \
##  		-backend-config="region=us-west-2" \
##  		-backend-config="encrypt=true"
