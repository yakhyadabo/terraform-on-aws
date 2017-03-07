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
		-backend-config="bucket=terraform-remote-state-storage-for-bastion" \
		-backend-config="key=terraform.tfstate" \
		-backend-config="region=us-east-1" \
		-backend-config="encrypt=true"

