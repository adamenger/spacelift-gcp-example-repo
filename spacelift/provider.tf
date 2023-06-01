variable "spacelift_key_id" {}
variable "spacelift_key_secret" {}

provider "spacelift" {
  api_key_endpoint = "https://wtfenterprises.app.spacelift.io"
  api_key_id       = var.spacelift_key_id
  api_key_secret   = var.spacelift_key_secret
}
