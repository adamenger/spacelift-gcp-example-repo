data "google_organization" "org" {
  domain = "atomic.computer"
}

resource "google_organization_iam_binding" "organization" {
  org_id  = data.google_organization.org.id
  role    = "roles/owner"

  members = [
    "user:adamenger@gmail.com",
  ]
}
