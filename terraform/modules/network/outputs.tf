output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.infra_vpc.id
}

output "subnetwork_id" {
  description = "ID of the backend subnet"
  value       = google_compute_subnetwork.subnet_backend.id
}
