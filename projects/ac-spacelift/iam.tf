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
  project  = google_project.ac-spacelift.id

  members = [
   "serviceAccount:${google_service_account.spacelift.email}",
  ]
}
