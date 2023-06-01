data "google_organization" "org" {
  domain = "atomic.computer"
}

resource "google_organization_iam_binding" "organization" {
  role    = "roles/owner"
  org_id  = data.google_organization.org.org_id

  members = [
   "serviceAccount:spacelift@ac-spacelift.iam.gserviceaccount.com",
  ]
}
