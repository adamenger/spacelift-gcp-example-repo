terraform {
  backend "gcs" {
    bucket = "ac-test-2-spacelift-state"
    prefix  = "terraform/state"
  }
}
