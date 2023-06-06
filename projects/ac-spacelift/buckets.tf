locals {
 stacks = yamldecode(file("../../stacks.yml"))
}

resource "google_storage_bucket" "state-buckets" {
  for_each      = toset(local.stacks.stacks)
  name          = "${each.value}-spacelift"
  project       = google_project.project.project_id
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_policy" "state-policy" {
  for_each      = toset(local.stacks.stacks)
  bucket        = google_storage_bucket.state-buckets[each.value].name
  policy_data   = data.google_iam_policy.state-admin.policy_data
}

data "google_iam_policy" "spacelift-state-admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:admin-adam@atomic.computer",
      "serviceAccount:${google_service_account.spacelift.email}",
    ]
  }
}
