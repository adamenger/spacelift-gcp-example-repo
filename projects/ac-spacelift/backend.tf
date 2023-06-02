terraform {
  backend "gcs" {
    bucket = "wtfenterprises-spacelift-state"
  }
}

provider "google" {
  project     = "ac-spacelift"
  region      = "us-central1"
}

resource "google_storage_bucket" "state" {
  name          = "wtfenterprises-spacelift-state"
  project       = google_project.project.project_id
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}
