data "google_organization" "org" {
  organization = "76970739165"
}

resource "google_organization_iam_binding" "owner" {
  role     = "roles/owner"
  org_id   = data.google_organization.org.org_id

  members = [
   "user:admin-adam@atomic.computer",
  ]
}

# these bindings allow spacelift-project-creator service account to create projects
resource "google_organization_iam_binding" "spacelift-project-creator" {
  role     = "roles/resourcemanager.projectCreator"
  org_id   = data.google_organization.org.org_id

  members = [
   "serviceAccount:spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com",
  ]
}

# these bindings allow spacelift-project-creator service account to add iam bindings to projects
resource "google_organization_iam_binding" "spacelift-project-iam" {
  role     = "roles/resourcemanager.projectIamAdmin"
  org_id   = data.google_organization.org.org_id

  members = [
   "serviceAccount:spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com",
  ]
}

# these bindings allow spacelift-project-creator service account to add iam bindings to projects
resource "google_organization_iam_binding" "spacelift-sa-creator" {
  role     = "roles/iam.serviceAccountAdmin"
  org_id   = data.google_organization.org.org_id

  members = [
   "serviceAccount:spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com",
  ]
}

# these bindings allow spacelift-project-creator service account to add iam bindings to projects
resource "google_organization_iam_binding" "spacelift-billing-user" {
  role     = "roles/billing.user"
  org_id   = data.google_organization.org.org_id

  members = [
   "serviceAccount:spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com",
  ]
}

resource "google_organization_iam_binding" "spacelift-api-admin" {
  role     = "roles/serviceusage.serviceUsageAdmin"
  org_id   = data.google_organization.org.org_id

  members = [
   "serviceAccount:spacelift-project-creator@ac-spacelift.iam.gserviceaccount.com",
  ]
}
