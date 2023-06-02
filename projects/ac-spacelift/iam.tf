# This service account is allocated to each node in the pool
resource "google_service_account" "node-pool" {
  account_id   = "gke-node-pool"
  display_name = "Node Pool Service Account"
}

# This SA is used for the spacelift pods via workload identity
resource "google_service_account" "spacelift" {
  account_id   = "spacelift"
  display_name = "Spacelift Service Account"
}

# Spacelift service account operator binding so spacelift can manage its own project
resource "google_project_iam_binding" "owner" {
  role     = "roles/owner"
  project  = google_project.project.id

  members = [
   "serviceAccount:${google_service_account.spacelift.email}",
  ]
}

# This binding lets the spacelift pods assume the GCP spacelift service account
resource "google_service_account_iam_binding" "spacelift-workload-identity" {
  role     = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.spacelift.name

  members = [
   "serviceAccount:ac-spacelift.svc.id.goog[default/spacelift-worker]",
  ]
}

# This service account is impersonated to create projects on the org
resource "google_service_account" "spacelift-project-creator" {
  account_id   = "spacelift"
  display_name = "Spacelift Org Project Creator"
}

# This binding lets the spacelift pods assume the GCP org wide project creator
resource "google_service_account_iam_binding" "spacelift-project-creator" {
  role     = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.spacelift-project-creator.name

  members = [
   "serviceAccount:ac-spacelift.svc.id.goog[default/spacelift-worker]",
  ]
}
