# Bootstrap — cria o bucket GCS para armazenar o Terraform state remotamente.
# Execute este diretório UMA VEZ antes de rodar o projeto principal:
#
#   cd terraform/bootstrap
#   terraform init
#   terraform apply
#
# Após a criação do bucket, configure o arquivo terraform/backend.tf com o nome gerado.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name          = var.state_bucket_name
  location      = var.region
  force_destroy = false

  # Mantém versões anteriores do state para facilitar rollback
  versioning {
    enabled = true
  }

  # Evita expor o bucket publicamente
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true

  labels = {
    managed-by = "terraform"
    purpose    = "terraform-state"
  }
}

output "state_bucket_name" {
  description = "Nome do bucket criado para o Terraform state"
  value       = google_storage_bucket.terraform_state.name
}
