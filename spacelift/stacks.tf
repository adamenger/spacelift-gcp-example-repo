locals {
 stacks = yamldecode(file("../stacks.yml"))
} 

resource "spacelift_stack" "managed-stacks" {
  for_each          = local.stacks
  name              = "Stack managed by Spacelift"
  repository        = "adamenger/spacelift-gcp-example-repo"
  branch            = "master"
  administrative    = true
  autodeploy        = true
  description       = "Provisions a Kubernetes cluster"
  name              = "Kubernetes Cluster"
  project_root      = "projects/${each.value}"
  terraform_version = "1.4.6"
}
