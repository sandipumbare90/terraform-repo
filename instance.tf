resource "google_compute_instance" "terraform-instance" {
    name = "terraform-instance"
    machine_type = "f1-micro"
    zone = "us-central1-c"
    labels = {
      dept = "evo-sl"
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
