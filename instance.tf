resource "google_compute_instance" "terraform-instance" {
    name = "terraform-instance"
    machine_type = "f1-micro"
    zone = "us-central1-c"
    labels = {
        demo = "CI/CD"
       }
    boot_disk {
      initialize_params{
      image = "debian-cloud/debian-11"
      }
    }
    network_interface {
      network = "default"
    access_config {
     
    }
    }
 
}
