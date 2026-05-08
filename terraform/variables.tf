variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "infra-vpc-terraform"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "subnet-backend-tf"
}

variable "subnet_cidr_range" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.0.1.0/24"
}

variable "firewall_name" {
  description = "Firewall rule name for SSH"
  type        = string
  default     = "allow-ssh-tf"
}

variable "ssh_source_ranges" {
  description = "Source CIDR ranges allowed to access SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vm_name" {
  description = "VM instance name"
  type        = string
  default     = "lab-app-server"
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
  default     = "e2-micro"
}

variable "image" {
  description = "Boot image reference"
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "artifact_repository_id" {
  description = "Artifact Registry repository ID for Docker images"
  type        = string
  default     = "arq-viewer-repo"
}

variable "artifact_repository_description" {
  description = "Artifact Registry repository description"
  type        = string
  default     = "Docker repository for Arq-Viewer app"
}
