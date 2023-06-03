provider "google" {
  project     = "atomic-computer-test-1"
  region      = "us-central1"
  #impersonate_service_account = "spacelift-operator@atomic-computer-test-1.iam.gserviceaccount.com"
  impersonate_service_account = "spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com"
}
