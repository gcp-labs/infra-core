# infra-core

Infrastructure definitions for the lab environment.

## Menu

* [Scripts (gcloud CLI)](./scripts/setup_network.sh)
* [Terraform](./terraform/main.tf)

## Repository Structure

* `scripts/`: shell-based provisioning via gcloud commands.
* `terraform/`: Terraform-based provisioning.

## Provisioning Options

* [scripts/setup_network.sh](./scripts/setup_network.sh): commands to create custom VPC, subnet, and SSH firewall rule.
* [terraform/main.tf](./terraform/main.tf): Terraform resources for provider, VPC, subnet, and firewall rule.
