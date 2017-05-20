default: plan

apply: 
	@terraform apply

destroy: 
	@terraform destroy

bastion-remote-config: 
	@terraform remote config \
		-backend=s3 \
		-backend-config="bucket=terraform-remote-state-for-bastion" \
		-backend-config="key=vpc/terraform.tfstate" \
		-backend-config="region=us-west-2" \
		-backend-config="encrypt=true"

