TF := terraform

.PHONY: init plan apply destroy clean

init:
	$(TF) init

plan: init
	$(TF) plan

apply: init
	$(TF) apply

destroy:
	$(TF) destroy -auto-approve

clean:
	@if [ -f terraform.tfstate ] || [ -f terraform.tfstate.backup ]; then \
		echo "Destroying existing AWS resources..."; \
		$(TF) destroy -auto-approve; \
	else \
		echo "No local Terraform state found; skipping destroy."; \
	fi
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup tfplan
