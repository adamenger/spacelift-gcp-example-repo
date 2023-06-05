module "spacelift-operator" {
  source = "../../modules/spacelift-operator"
  project = google_project.project.id
  spacelift_worker_service_account = "spacelift@ac-spacelift.iam.gserviceaccount.com"
  operator_roles = [
    "pubsub.admin",
    "storage.admin",
    "owner",
  ]
}
