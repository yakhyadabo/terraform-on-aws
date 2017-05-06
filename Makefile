default: plan

plan: 
	@terraform plan

apply: 
	@terraform apply

destroy: 
	@terraform destroy

save-state: 
	@terraform remote config \
		-backend=s3 \
		-backend-config="bucket=terraform-remote-state-for-bastion" \
		-backend-config="key=terraform.tfstate" \
		-backend-config="region=us-wes-2" \
		-backend-config="encrypt=true"

