locals {
 stacks = yamldecode(file("../stacks.yml"))
} 

resource "spacelift_stack" "managed-stacks" {
  for_each          = toset(local.stacks)
  terraform_version = "1.4.6"

  name              = "AC ${each.value}"
  repository        = "adamenger/spacelift-gcp-example-repo"
  branch            = "master"
  project_root      = "projects/${each.value}"
  administrative    = false
  autodeploy        = false

}
