locals {
 stacks = yamldecode(file("../stacks.yml"))
} 

resource "spacelift_stack" "managed-stacks" {
  for_each          = toset(local.stacks.stacks)
  terraform_version = "1.4.6"

  name              = "GCP: ${each.value}"
  repository        = "spacelift-gcp-example-repo"
  branch            = "master"
  project_root      = "projects/${each.value}"
  administrative    = false
  autodeploy        = false

}
