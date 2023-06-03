# Each project gets its own spacelift-operator account
resource "google_service_account" "spacelift-operator" {
  account_id   = "spacelift-operator"
  display_name = "Spacelift Operator"
}

# Spacelift service account operator binding so the project spacelift can manage its own project
resource "google_project_iam_binding" "owner" {
  role     = "roles/owner"
  project  = google_project.project.id

  members = [
   "serviceAccount:${google_service_account.spacelift-operator.email}",
  ]
}

# This binding lets the main spacelift account assume the project account
resource "google_service_account_iam_binding" "spacelift-operator" {
  role     = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.spacelift-operator.name

  members = [
   "serviceAccount:spacelift@ac-spacelift.iam.gserviceaccount.com",
  ]
}
