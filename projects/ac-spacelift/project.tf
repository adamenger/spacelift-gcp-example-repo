data "google_organization" "org" {
  domain = "atomic.computer"
}

data "google_billing_account" "account" {
  display_name = "My Billing Account"
  open         = true
}

resource "google_project" "ac-spacelift" {
  name       = "AC Spacelift"
  project_id = "ac-spacelift"
  org_id     = data.google_organization.org.org_id
  billing_account = data.google_billing_account.account.id
}
