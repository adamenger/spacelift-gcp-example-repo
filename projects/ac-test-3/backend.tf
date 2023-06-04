terraform {
  backend "gcs" {
    bucket = "ac-test-3-spacelift-state"
    prefix  = "terraform/state"
  }
}
