resource "google_storage_bucket" "ac-test-1-state" {
  name          = "ac-test-1-spacelift-state"
  project       = google_project.project.project_id
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_policy" "ac-test-1-state-policy" {
  bucket        = google_storage_bucket.ac-test-1-state.name
  policy_data   = data.google_iam_policy.ac-test-1-state-admin.policy_data
}

data "google_iam_policy" "ac-test-1-state-admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:admin-adam@atomic.computer",
      "serviceAccount:${google_service_account.spacelift.email}",
    ]
  }
}
