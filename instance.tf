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
 
}
