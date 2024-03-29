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

