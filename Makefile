.PHONY: eks ec2 destroy-eks destroy-ec2

EMAIL=hemantksingh.hk@gmail.com
TERRAFORM_DIR=.

define tfinit
	cd $(TERRAFORM_DIR)/$(1) && terraform init
endef

eks:
	$(call tfinit,$@) && \
	terraform plan \
		-var email=$(EMAIL) \
		-out $@.tfplan
ifeq ($(APPLY), true)
	cd $(TERRAFORM_DIR)/$@ && \
	terraform apply $@.tfplan
else
	@echo Skipping apply ...
endif

destroy-eks:
	cd $(TERRAFORM_DIR)/eks && \
	terraform destroy -var email=$(EMAIL)

ec2:
	$(call tfinit,$@) && \
	terraform plan \
		-var email=$(EMAIL) \
		-out $@.tfplan
ifeq ($(APPLY), true)
	cd $(TERRAFORM_DIR)/$@ && \
	terraform apply $@.tfplan
else
	@echo Skipping apply ...
endif

destroy-ec2:
	cd $(TERRAFORM_DIR)/ec2 && \
		terraform destroy -var email=$(EMAIL)
