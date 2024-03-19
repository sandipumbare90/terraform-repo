resource "google_compute_instance" "terraform-instance" {
    name = "jenkins-managed-node1"
    machine_type = "f1-micro"
    zone = "us-central1-c"
    labels = {
      dept = "information technology"
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
