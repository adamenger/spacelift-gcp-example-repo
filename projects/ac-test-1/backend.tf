terraform {
  backend "gcs" {
    bucket = "ac-test-1-spacelift-state"
    prefix  = "terraform/state"
  }
}
