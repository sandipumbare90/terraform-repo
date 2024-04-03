resource google_compute_instance "my-first-instance" {
        name = "managed-node-01"
        project = "devops-engineer-123"
        machine_type = "e2-medium"
        zone = "us-central1-a"
        labels  = {
          team = "gcp-teams"

         }
        boot_disk {
          initialize_params {
            image = "debian-cloud/debian-12"
                            }

                  }

        network_interface {
          network = "my-vpc-01"
          subnetwork = "subnet-01"
          access_config {
}
          
}

}
