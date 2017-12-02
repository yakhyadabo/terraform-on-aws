default: plan

plan: 
	@terraform plan 

apply: 
	@terraform apply

destroy: 
	@terraform destroy

init: 
	@terraform init \
 		-backend-config="bucket=terraform-remote-state-zeta" \
 		-backend-config="key=dev/terraform.tfstate" \
 		-backend-config="region=us-west-2" \
 		-backend-config="encrypt=true"
