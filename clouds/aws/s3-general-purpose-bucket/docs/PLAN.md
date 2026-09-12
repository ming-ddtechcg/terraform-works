# Project Plan - S3 test

1. Generate an S3 Terraform template file with the required parameters. ✅
   - **Bucket type is a General Purpose bucket** — `aws_s3_bucket` always provisions a general purpose (regional) bucket, not an S3 Express One Zone directory bucket (directory buckets require a different resource/config), so no extra argument is needed for this.
   - `providers.tf` — AWS provider (`~> 5.0`), region `us-east-2`
   - `variables.tf` — `bucket_name` (required), `environment`, `project`, `enable_versioning`, `sse_algorithm`, `enable_public_access`, `force_destroy`
   - `main.tf` — `aws_s3_bucket` with versioning, server-side encryption (AES256), public access block, and a bucket policy
   - `outputs.tf` — bucket id and ARN

2. Conditions:
   - **Allow the section for the public or private access.** ✅ `var.enable_public_access` (bool, default `false`) toggles the bucket between private and public:
     - `false` (private, default): `public_access_block` blocks all public policy/ACLs (`block_public_policy = true`, `restrict_public_buckets = true`); the `aws_iam_policy_document.public` data source and `aws_s3_bucket_policy.this` resource are both `count`-gated to `0`, so no bucket policy exists at all (not just an empty one).
     - `true` (public): `public_access_block` opens `block_public_policy`/`restrict_public_buckets` to `false`, and a `PublicReadWriteList` bucket policy statement is created granting `Principal: "*"` → `s3:GetObject`, `s3:PutObject`, `s3:ListBucket` on the bucket and its objects.

3. Build a Makefile for `terraform init`, `plan`, and `destroy`. In addition, a `make clean` to destroy all AWS resources if they were created and remove the files/directories created by Terraform. ✅
   - `make init` — `terraform init`
   - `make plan BUCKET_NAME=<name> ENABLE_PUBLIC_ACCESS=<true|false>` — init + `terraform plan`
   - `make apply BUCKET_NAME=<name> ENABLE_PUBLIC_ACCESS=<true|false>` — init + `terraform apply` (prompts for confirmation; creates the real AWS resources)
   - `make destroy BUCKET_NAME=<name> ENABLE_PUBLIC_ACCESS=<true|false>` — `terraform destroy -auto-approve` (no confirmation prompt)
   - `make clean` — destroys resources if local state exists (`terraform destroy -auto-approve`), then removes `.terraform/`, `.terraform.lock.hcl`, `terraform.tfstate*`, `tfplan`
   - **Ensure the bucket is empty before deletion, otherwise `terraform destroy` fails with `BucketNotEmpty`** (S3 requires every object *version* and delete marker to be gone, not just the current objects — a versioned bucket that "looks empty" via `aws s3 ls` can still block deletion). ✅ Handled via `var.force_destroy` (default `true`) on `aws_s3_bucket.this`: when set, `terraform destroy` deletes all objects, object versions, and delete markers itself before removing the bucket — so both `make destroy` and `make clean` work non-interactively even if objects were added outside Terraform.
   - **`-auto-approve`** ✅ included on both `destroy` and `clean`'s `terraform destroy` calls, so no interactive confirmation is required.

> **Note:** Setting `enable_public_access = true` allows anyone on the internet to read, list, and upload/overwrite objects in the bucket. Use it only for a disposable test bucket; leave it `false` (the default) for anything else.

> **Note:** `destroy` and `clean` pass `-auto-approve` and rely on `force_destroy = true`, so they skip Terraform's "do you really want to destroy" prompt and immediately delete the bucket *and everything in it*, with no way to undo — double-check `BUCKET_NAME`/`ENABLE_PUBLIC_ACCESS` before running them. Set `-var="force_destroy=false"` if you want an extra safety net that fails instead of silently wiping a non-empty bucket.

## Usage

```sh
# Preview a private bucket
make plan BUCKET_NAME=my-unique-bucket-name

# Create it
make apply BUCKET_NAME=my-unique-bucket-name

# Preview/create a public bucket instead
make plan  BUCKET_NAME=my-unique-bucket-name ENABLE_PUBLIC_ACCESS=true
make apply BUCKET_NAME=my-unique-bucket-name ENABLE_PUBLIC_ACCESS=true

# Tear down the bucket (must pass the same BUCKET_NAME/ENABLE_PUBLIC_ACCESS used to create it)
make destroy BUCKET_NAME=my-unique-bucket-name

# Destroy (if needed) and wipe all local Terraform files/state
make clean BUCKET_NAME=my-unique-bucket-name
```
