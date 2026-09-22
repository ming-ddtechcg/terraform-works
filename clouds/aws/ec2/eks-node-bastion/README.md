# Bastion setup

To setup a bastion host in the public subnet, it takes the SSH access with the SSH key-pair.  Another hand, the bastion can access the EC2 (simulate an EKS node) in the private subnet).

## create a bastion and an eks node

```bash
$ terraform init
```

or

```bash
$ terraform plan -var "deployment_name=<deployment_name>"
$ terraform apply -var "deployment_name=<deployment_name> --auto-approve
```

## destroy all resources

```bash
$ terraform destroy -var "deployment_name=<deployment_name> --auto-approve"
```
