resource "google_storage_bucket" "gcs-bucket-for-backend-state-files" {
        name = "gcs-bucket-for-backend-state-files"
        location = "US"
        force_destroy = "true"
        uniform_bucket_level_access = true
	versioning {
 	enabled = true 
 }
}
