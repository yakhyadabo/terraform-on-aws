default: plan

plan: 
	@terraform plan 

apply: 
	@terraform apply

destroy: 
	@terraform destroy

bastion-remote-config: 
	@terraform remote config \
		-backend=s3 \
		-backend-config="bucket=terraform-remote-state-zeta" \
		-backend-config="key=dev/terraform.tfstate" \
		-backend-config="region=us-west-2" \
		-backend-config="encrypt=true"

