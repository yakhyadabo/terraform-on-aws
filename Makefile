DEV=env-dev
SHARED=env-shared


format: 
	@terraform fmt


#### VPC ####

vpc-init: 
	@cd ${DEV}/vpc && terraform init

vpc-plan: 
	@cd ${DEV}/vpc && terraform plan 

vpc-create: 
	@cd ${DEV}/vpc && terraform apply

vpc-destroy: 
	@cd ${DEV}/vpc && terraform destroy


#### kube-demo ####

kube-demo-init: 
	@cd ${DEV}/kube-demo && terraform init

kube-demo-plan: 
	@cd ${DEV}/kube-demo && terraform plan 

kube-demo-create: 
	@cd ${DEV}/kube-demo && terraform apply

kube-demo-destroy: 
	@cd ${DEV}/kube-demo && terraform destroy

kube-demo-config: 
	@cd ${DEV}/kube-demo && terraform output kubeconfig > ~/.kube/config

kube-demo-auth: 
	@cd ${DEV}/kube-demo && terraform output config-map-aws-auth > ~/.kube/config-map-aws-auth.yml

### users

users-init: 
	@cd ${SHARED}/users && terraform init

users-plan: 
	@cd ${SHARED}/users && terraform plan 

users-create: 
	@cd ${SHARED}/users && terraform apply

users-destroy: 
	@cd ${SHARED}/users && terraform destroy

### Services

services-init: 
	@cd ${DEV}/services && terraform init

services-plan: 
	@cd ${DEV}/services && terraform plan 

services-create: 
	@cd ${DEV}/services && terraform apply

services-destroy: 
	@cd ${DEV}/services && terraform destroy


### Wordpress DB

wordpress-db-init: 
	@cd ${DEV}/storage/wordpress-db && terraform init

wordpress-db-plan: 
	@cd ${DEV}/storage/wordpress-db && terraform plan 

wordpress-db-create: 
	@cd ${DEV}/storage/wordpress-db && terraform apply

wordpress-db-destroy: 
	@cd ${DEV}/storage/wordpress-db && terraform destroy


### DNS 

dns-init: 
	@cd ${SHARED}/dns && terraform init

dns-plan: 
	@cd ${SHARED}/dns && terraform plan 

dns-create: 
	@cd ${SHARED}/dns && terraform apply

dns-destroy: 
	@cd ${SHARED}/dns && terraform destroy
