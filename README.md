# infra-core

Infrastructure definitions for the lab environment.

## Menu

- [Terraform](./terraform)

## Repository Structure

- `terraform/`: infrastructure provisioning with Terraform modules.

## Current Layout

- `terraform/backend.tf`: remote state backend configuration (GCS).
- `terraform/main.tf`: root Terraform entrypoint with provider, module calls, and Artifact Registry resource.
- `terraform/variables.tf`: centralized input variables for project, region, zone, and resource names.
- `terraform/outputs.tf`: outputs with integration-ready values (for example, Artifact Registry path).
- `terraform/terraform.tfvars.example`: example values for environment customization.
- `terraform/bootstrap/main.tf`: one-time setup to create the GCS bucket for remote state storage.
- `terraform/bootstrap/variables.tf`: input variables for the bootstrap configuration.
- `terraform/bootstrap/terraform.tfvars.example`: example values for the bootstrap configuration.
- `terraform/modules/network/main.tf`: network resources (VPC, subnet, firewall).
- `terraform/modules/network/outputs.tf`: network module outputs used by other modules.
- `terraform/modules/vms/main.tf`: VM resources.

## Remote State

Terraform state is stored remotely in a GCS bucket, keeping it out of the repository and enabling versioning and rollback.

### Step 1 - Create the state bucket (run once)

```bash
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project_id and desired bucket name
terraform init
terraform apply
```

### Step 2 - Configure the backend

Update `terraform/backend.tf` with the bucket name created in Step 1 if you changed the default name.

## Container Infrastructure (Artifact Registry)

The root Terraform configuration creates a Docker repository in Artifact Registry to store frontend application images.

- Resource: `google_artifact_registry_repository.app_repo`
- Location: `var.region`
- Default repository name: `arq-viewer-repo`

Root variables related to Artifact Registry:

- `artifact_repository_id`
- `artifact_repository_description`

Output:

- `artifact_registry_repository`: format `REGION-docker.pkg.dev/PROJECT/REPO`

## Provisioning

1. Complete the [Remote State](#remote-state) setup above (once per project).
2. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and update values.
3. Initialize Terraform in the `terraform` folder (this connects to the remote backend).
4. Run `terraform plan` and `terraform apply`.

Example:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

After `apply`, get the repository base URL:

```bash
terraform output artifact_registry_repository
```

## Apply From Google Cloud Shell

Use this flow when running from Cloud Shell against a test project such as `your-project`.

1. Open Cloud Shell and clone the repository.
2. Set your active GCP project.
3. Enable required APIs.
4. Create the remote state bucket (bootstrap step).
5. Configure Terraform variables.
6. Run init, plan, and apply.

Example:

```bash
git clone https://github.com/gcp-labs/infra-core.git
cd infra-core

gcloud config set project your-project
gcloud services enable \
  compute.googleapis.com \
  storage.googleapis.com \
  artifactregistry.googleapis.com \
  run.googleapis.com

# Bootstrap - create the GCS bucket for remote state (run once)
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
sed -i 's/^project_id.*/project_id        = "your-project"/' terraform.tfvars
terraform init
terraform apply

# Main infrastructure
cd ../
cp terraform.tfvars.example terraform.tfvars

# Optional: edit values if needed (region, zone, names, CIDR)
sed -i 's/^project_id.*/project_id        = "your-project"/' terraform.tfvars

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

- `project_id`
- `region`
- `zone`
- `network_name`
- `subnet_name`
- `subnet_cidr_range`
- `firewall_name`
- `ssh_source_ranges`
- `vm_name`
- `machine_type`
- `image`
- `artifact_repository_id`
- `artifact_repository_description`

The bootstrap variables include:

- `project_id`
- `region`
- `state_bucket_name`

## Frontend Docker for Cloud Run

For your local frontend project (outside this repository), use a multi-stage Dockerfile and configure Nginx to listen on port `8080` (Cloud Run default).

Example `Dockerfile`:

```dockerfile
FROM node:20-slim AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

Example `nginx.conf`:

```nginx
server {
  listen 8080;
  server_name _;

  root /usr/share/nginx/html;
  index index.html;

  location / {
    try_files $uri /index.html;
  }
}
```

## Build, Push, Deploy Order (Recommended)

Yes: build and push the image first, then point Cloud Run to that image URI.

```bash
# Variables
PROJECT_ID="your-project"
REGION="us-central1"
REPO="arq-viewer-repo"
IMAGE="frontend"
TAG="v1"

IMAGE_URI="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE}:${TAG}"

# 1) Build and push image
gcloud auth configure-docker "${REGION}-docker.pkg.dev"
docker build -t "${IMAGE_URI}" .
docker push "${IMAGE_URI}"

# 2) Deploy to Cloud Run using the pushed image
gcloud run deploy arq-viewer-frontend \
  --image "${IMAGE_URI}" \
  --platform managed \
  --region "${REGION}" \
  --allow-unauthenticated
```

This repository provisions the infrastructure (including Artifact Registry). Your frontend repository builds the container image and pushes it to the registry created here.
