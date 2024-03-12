terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.20.0"
    }
  }
}

provider "google" {
        project = "devops-engineer-123"
        region = "us-central1"
}

#Terraform state in a Cloud Storage bucket
backend "gcs" {
   bucket  = "gcs-bucket-for-tf-state-file"
   prefix  = "terraform/state"
}

resource "google_storage_bucket" "gcs-bucket-for-tf-state-file" {
	name = "gcs-bucket-for-tf-state-file"
	location = "US"
	force_destroy = "true"
	retention_policy {
	  retention_period = "2,147,483,647"
    }
	versioning {
          enabled = true
   }
}
