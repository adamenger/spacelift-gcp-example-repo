module "spacelift-operator" {
  source = "../../modules/spacelift-operator"
  spacelift_worker_service_account = "spacelift@ac-spacelift.iam.gserviceaccount.com"
  operator_roles = [
    "pubsub.admin",
  ]
}
