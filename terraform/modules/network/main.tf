variable "region" {
  description = "GCP region for subnet resources"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_cidr_range" {
  description = "CIDR range of the subnet"
  type        = string
}

variable "firewall_name" {
  description = "Name of the SSH firewall rule"
  type        = string
}

variable "ssh_source_ranges" {
  description = "Allowed source ranges for SSH ingress"
  type        = list(string)
}

# 1. Create the VPC
resource "google_compute_network" "infra_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false # Equivalent to --subnet-mode=custom
}

# 2. Create the subnet
resource "google_compute_subnetwork" "subnet_backend" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr_range
  region        = var.region
  network       = google_compute_network.infra_vpc.id
}

# 3. Create the SSH firewall rule
resource "google_compute_firewall" "allow_ssh" {
  name    = var.firewall_name
  network = google_compute_network.infra_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
}
