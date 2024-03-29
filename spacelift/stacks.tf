locals {
 stacks = yamldecode(file("../stacks.yml"))
} 

# managing spacelift with spacelift, woah
resource "spacelift_stack" "spacelift" {
  terraform_version = "1.4.6"
  github_enterprise {
    namespace       = "adamenger"
  }

  name              = "Spacelift"
  repository        = "spacelift-gcp-example-repo"
  branch            = "master"
  project_root      = "spacelift/"
  administrative    = true
  autodeploy        = false
  terraform_external_state_access = true
}

resource "spacelift_stack" "managed-stacks" {
  for_each          = toset(local.stacks.stacks)
  terraform_version = "1.4.6"
  github_enterprise {
    namespace       = "adamenger"
  }

  name              = "GCP: ${each.value}"
  repository        = "spacelift-gcp-example-repo"
  branch            = "master"
  project_root      = "projects/${each.value}"
  administrative    = false
  autodeploy        = false
  worker_pool_id    = spacelift_worker_pool.k8s.id

}
