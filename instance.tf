resource "google_compute_instance" "terraform-instance" {
    name = "jenkins-managed-node1"
    machine_type = "e2-medium"
    zone = "us-central1-c"
    labels = {
      dept = "it"
      team = "gcp"
	}
    boot_disk {
      initialize_params{
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      }
    }
    network_interface {
      network = "default"
    access_config {
     
     }
    } 
    lifecycle {
    ignore_changes = [attached_disk]
    }
}

resource "google_compute_disk" "disk-for-instance" {
    name = "data-disk-1"
    type = "pd-standard"
    size = "10"
    zone = "us-central1-c"
    physical_block_size_bytes = "4096"
}

resource "google_compute_attached_disk" "default" {
    disk = google_compute_disk.disk-for-instance.name
    instance = google_compute_instance.terraform-instance.name
    zone = "us-central1-c"
}

