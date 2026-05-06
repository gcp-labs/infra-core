# infra-core

Infrastructure definitions for the lab environment.

## Menu

* [Terraform](./terraform)

## Repository Structure

* `terraform/`: Terraform-based provisioning using modules.

## Current Layout

* `terraform/main.tf`: root Terraform entrypoint with provider and module calls.
* `terraform/variables.tf`: centralized input variables for project, region, zone, and resource names.
* `terraform/terraform.tfvars.example`: example values for environment customization.
* `terraform/modules/network/main.tf`: network resources (VPC, subnet, firewall).
* `terraform/modules/network/outputs.tf`: network module outputs used by other modules.
* `terraform/modules/vms/main.tf`: VM resources.

## Provisioning

1. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and update values.
2. Initialize Terraform in the `terraform` folder.
3. Run `terraform plan` and `terraform apply`.

Example:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Apply From Google Cloud Shell

Use this flow when running from Cloud Shell against a test project such as `your-project`.

1. Open Cloud Shell and clone the repository.
2. Set your active GCP project.
3. Enable required APIs.
4. Configure Terraform variables.
5. Run init, plan, and apply.

Example:

```bash
git clone https://github.com/gcp-labs/infra-core.git
cd infra-core

gcloud config set project your-project
gcloud services enable compute.googleapis.com

cd terraform
cp terraform.tfvars.example terraform.tfvars

# Optional: edit values if needed (region, zone, names, CIDR)
sed -i 's/^project_id.*/project_id        = "gcp-labs-core-495514"/' terraform.tfvars

terraform init
terraform plan
terraform apply
```

To avoid extra costs after testing:

```bash
cd terraform
terraform destroy
```

## Configurable Variables

The root variables include:

* `project_id`
* `region`
* `zone`
* `network_name`
* `subnet_name`
* `subnet_cidr_range`
* `firewall_name`
* `ssh_source_ranges`
* `vm_name`
* `machine_type`
* `image`
