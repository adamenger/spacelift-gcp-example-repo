resource "google_service_account" "node-pool" {
  account_id   = "gke-node-pool"
  display_name = "Node Pool Service Account"
}

resource "google_service_account" "spacelift" {
  account_id   = "spacelift"
  display_name = "Spacelift Service Account"
}

resource "google_project_iam_binding" "organization" {
  role     = "roles/iam.workloadIdentityUser"
  project  = google_project.ac-spacelift.id

  members = [
   "serviceAccount:ac-spacelift.svc.id.goog[spacelift/spacelift]",
  ]
}
