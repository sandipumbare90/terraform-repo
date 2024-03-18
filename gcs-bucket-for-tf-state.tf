resource "google_storage_bucket" "gcs-bucket" {
        name = "gcs-bucket"
        location = "US"
        force_destroy = "true"
        retention_policy {
          retention_period = "2,147,483,647"
    }
        versioning {
          enabled = true
   }
}
