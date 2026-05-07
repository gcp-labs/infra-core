terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Remote state no GCS — substitua o valor de "bucket" pelo nome criado no bootstrap.
  # Após alterar, rode: terraform init -reconfigure
  backend "gcs" {
    bucket = "gcp-labs-core-tfstate"   # mesmo nome definido em bootstrap/terraform.tfvars
    prefix = "terraform/state"
  }
}
