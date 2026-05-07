variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region where the bucket will be created"
  type        = string
  default     = "us-central1"
}

variable "state_bucket_name" {
  description = "Globally unique name of the GCS bucket to store the Terraform state."
  type        = string
}
