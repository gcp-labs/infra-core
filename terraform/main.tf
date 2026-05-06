# Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source            = "./modules/network"
  region            = var.region
  network_name      = var.network_name
  subnet_name       = var.subnet_name
  subnet_cidr_range = var.subnet_cidr_range
  firewall_name     = var.firewall_name
  ssh_source_ranges = var.ssh_source_ranges
}

module "vms" {
  source        = "./modules/vms"
  zone          = var.zone
  vm_name       = var.vm_name
  machine_type  = var.machine_type
  image         = var.image
  network_id    = module.network.network_id
  subnetwork_id = module.network.subnetwork_id
}
