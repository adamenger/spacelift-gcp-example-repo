resource "spacelift_worker_pool" "k8s" {
  name        = "k8s"
  csr         = filebase64("../spacelift.csr")
  description = "k8s worker pool"
}
