TF := terraform

BUCKET_NAME ?=
ENABLE_PUBLIC_ACCESS ?=
TF_VARS := $(if $(BUCKET_NAME),-var="bucket_name=$(BUCKET_NAME)") $(if $(ENABLE_PUBLIC_ACCESS),-var="enable_public_access=$(ENABLE_PUBLIC_ACCESS)")

.PHONY: init plan apply destroy clean

init:
	$(TF) init

plan: init
	$(TF) plan $(TF_VARS)

apply: init
	$(TF) apply $(TF_VARS)

destroy:
	$(TF) destroy $(TF_VARS) -auto-approve

clean:
	@if [ -f terraform.tfstate ] || [ -f terraform.tfstate.backup ]; then \
		echo "Destroying existing AWS resources..."; \
		$(TF) destroy $(TF_VARS) -auto-approve; \
	else \
		echo "No local Terraform state found; skipping destroy."; \
	fi
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup tfplan
