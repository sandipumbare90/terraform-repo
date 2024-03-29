terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.22.0"
    }
  }
  experiments = [module_variable_optional_attrs]
  backend "gcs" {
    bucket = "gcs-bucket-for-backend-state-files"
    prefix = "terraform-1/state"
}
}

provider "google" {
  project = "devops-engineer-123"
  region = "us-central1"
  impersonate_service_account = "jenkins-sa-cicd@devops-engineer-123.iam.gserviceaccount.com"
}
