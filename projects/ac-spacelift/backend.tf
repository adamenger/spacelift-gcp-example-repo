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

resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.state.name
  policy_data = data.google_iam_policy.state-admin.policy_data
}

data "google_iam_policy" "state-admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:admin-adam@atomic.computer",
      "serviceAccount:${google_service_account.spacelift.email}",
    ]
  }
}
