resource "google_service_account" "node-pool" {
  account_id   = "gke-node-pool"
  display_name = "Node Pool Service Account"
}

resource "google_service_account" "spacelift" {
  account_id   = "spacelift"
  display_name = "Spacelift Service Account"
}

resource "google_service_account_iam_binding" "spacelift-workload-identity" {
  role     = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.spacelift.name

  members = [
   "serviceAccount:ac-spacelift.svc.id.goog[default/spacelift-worker]",
  ]
}

resource "google_project_iam_binding" "owner" {
  role     = "roles/owner"
  project  = google_project.project.id

  members = [
   "serviceAccount:${google_service_account.spacelift.email}",
  ]
}

data "google_iam_policy" "state-admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:admin-adam@atomic.computer",
    ]
  }
}

data "google_iam_policy" "state-writer" {
  binding {
    role = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:${google_service_account.spacelift.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "admin-policy" {
  bucket = google_storage_bucket.state.name
  policy_data = data.google_iam_policy.state-admin.policy_data
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.state.name
  policy_data = data.google_iam_policy.state-writer.policy_data
}
