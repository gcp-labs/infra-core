# Provider Configuration
provider "google" {
  project = "gcp-labs-core-495514" # Use your Project ID here
  region  = "us-central1"
}

# 1. Create the VPC
resource "google_compute_network" "infra_vpc" {
  name                    = "infra-vpc-terraform"
  auto_create_subnetworks = false # This is equivalent to --subnet-mode=custom
}

# 2. Create the Subnet
resource "google_compute_subnetwork" "subnet_backend" {
  name          = "subnet-backend-tf"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.infra_vpc.id
}

# 3. Create the Firewall Rule
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-tf"
  network = google_compute_network.infra_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
