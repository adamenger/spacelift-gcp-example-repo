# Each project gets its own spacelift-operator account
# The spacelift-worker account will impersonate this account to perform operations inside of the project
resource "google_service_account" "spacelift-operator" {
  account_id   = "spacelift-operator"
  display_name = "Spacelift Operator"
}

# This binding grants any roles set on the module to the spacelift-operator account
resource "google_project_iam_binding" "operator-roles" {
  for_each   = toset(local.operator_roles)
  role     = "roles/${each.key}"
  project  = google_project.project.id

  members = [
   "serviceAccount:${google_service_account.spacelift-operator.email}",
  ]
}

# This binding lets the spacelift main spacelift worker account impersonate the project account
resource "google_service_account_iam_binding" "impersonation" {
  role     = "roles/iam.serviceAccountTokenCreator"
  service_account_id = google_service_account.spacelift-operator.name

  members = [
   "serviceAccount:${var.spacelift_worker_service_account}",
  ]
}
