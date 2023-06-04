variable "spacelift_worker_service_account" {
  description = "The address of the service account attached to the Spacelift Workers"
  type        = string
}

variable "operator_roles" {
  description = "Roles to set on the Spacelift Operator service account"
  type        = list(string)
  default     = []
}

variable "project" {
  description = "Project to create the service account on"
  type        = string
}
