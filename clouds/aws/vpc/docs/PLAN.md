# Project Plan - VPC

1. Generate a VPC Terraform template with the required parameters. ✅
   - **Based on the specific region** — `providers.tf` configures the AWS provider with `region = var.aws_region` (default `us-east-2`).
   - **The VPC lands in the specific CIDR** — `var.vpc_cidr` (default `10.0.0.0/16`) is passed to `aws_vpc.this`.
   - **Two public and two private subnets, each pair spread across two different availability zones** — `var.availability_zones` (default `["us-east-2a", "us-east-2b"]`) drives `count = 2` on both `aws_subnet.public` and `aws_subnet.private`, pairing `var.public_subnet_cidrs[count.index]` / `var.private_subnet_cidrs[count.index]` with `var.availability_zones[count.index]`. Public subnets set `map_public_ip_on_launch = true`; private subnets don't.
   - **Route table entries for both public and private subnets** — `aws_route_table.public` gets an explicit `aws_route` to `0.0.0.0/0` via the internet gateway, and both public subnets are associated to it with `aws_route_table_association.public`. `aws_route_table.private` is a separate route table (local-only route, since no NAT gateway was requested) associated to both private subnets via `aws_route_table_association.private`.
   - **Internet gateway for VPC ↔ internet access** — `aws_internet_gateway.this` is attached to the VPC and referenced by the public route.
   - **Security group for public access, attached to the VPC** — `aws_security_group.public` is created on `aws_vpc.this` with a dynamic ingress rule per port in `var.public_ingress_ports` (default `22, 80, 443`) open to `0.0.0.0/0`, and a single egress rule allowing all outbound traffic.
   - `variables.tf` — `aws_region`, `vpc_cidr`, `availability_zones`, `public_subnet_cidrs`, `private_subnet_cidrs`, `public_ingress_ports`, `environment`, `project`
   - `outputs.tf` — VPC id, internet gateway id, public/private subnet ids, public/private route table ids, public security group id

2. Build a Makefile for `terraform init`, `plan`, and `destroy`. ✅
   - `make init` — `terraform init`
   - `make plan` — init + `terraform plan`
   - `make apply` — init + `terraform apply` (prompts for confirmation; creates the real AWS resources)
   - `make destroy` — `terraform destroy -auto-approve` (no confirmation prompt)

3. `make clean` destroys all AWS resources if created and removes the files/directories Terraform created. ✅
   - Destroys resources if local state exists (`terraform destroy -auto-approve`), then removes `.terraform/`, `.terraform.lock.hcl`, `terraform.tfstate*`, `tfplan`.

> **Note:** Private subnets have no route to the internet (no NAT gateway is created) — they only get the VPC's default local route. Add a NAT gateway/route separately if outbound internet access from private subnets is needed later.

> **Note:** The public security group opens ports 22/80/443 to `0.0.0.0/0` by default — it is created but not attached to any instance/ENI by this module. Attach `aws_security_group.public` (via its id output) to whatever compute resources you launch into the public subnets, and narrow `var.public_ingress_ports` / add a bastion or restrict source CIDRs before using this for anything beyond disposable testing.

> **Note:** `destroy` and `clean` pass `-auto-approve`, so they skip Terraform's "do you really want to destroy" confirmation and immediately tear down the VPC and everything in it, with no way to undo.

## Usage

```sh
# Preview with defaults (10.0.0.0/16 in us-east-2a/us-east-2b)
make plan

# Create it
make apply

# Override region/CIDR/AZs as needed
terraform plan -var="aws_region=us-west-2" -var="vpc_cidr=10.1.0.0/16" -var='availability_zones=["us-west-2a","us-west-2b"]'

# Tear down
make destroy

# Destroy (if needed) and wipe all local Terraform files/state
make clean
```
