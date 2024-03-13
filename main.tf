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
	impersonate_service_account = "jenkins-cicd-sa@devops-engineer-123.iam.gserviceaccount.com"
}

