resource "google_storage_bucket" "gcs-bucket" {
        name = "gcs-bucket"
        location = "US"
        force_destroy = "true"
}
