provider "google" {
  project     = "atomic-computer-test-2"
  region      = "us-central1"
  #impersonate_service_account = "spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com"
  impersonate_service_account = "spacelift-operator@atomic-computer-test-2.iam.gserviceaccount.com"
}


