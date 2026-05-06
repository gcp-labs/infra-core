variable "zone" {
  description = "GCP zone where VM instances are created"
  type        = string
}

variable "vm_name" {
  description = "VM instance name"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
}

variable "image" {
  description = "Boot disk image (project/family or project/image)"
  type        = string
}

variable "network_id" {
  description = "VPC network ID for VM NIC"
  type        = string
}

variable "subnetwork_id" {
  description = "Subnet ID for VM NIC"
  type        = string
}

# 4. Create the VM instance (Compute Engine)
resource "google_compute_instance" "app_server" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnetwork_id

    access_config {
      # Keep empty to assign an ephemeral external IP.
    }
  }

  metadata_startup_script = <<-EOT
    mkdir -p /var/www/html
    echo 'Hello from GCP Labs' > /var/www/html/index.html
  EOT
}
