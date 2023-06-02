# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "google_compute_subnetwork" "spacelift-subnet" {
  name          = "spacelift-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.spacelift-network.id

  secondary_ip_range {
    range_name    = "spacelift-pod-subnet"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "spacelift-service-subnet"
    ip_cidr_range = "10.2.0.0/16"
  }

}

resource "google_compute_network" "spacelift-network" {
  name                    = "spacelift-network"
  auto_create_subnetworks = false
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = google_project.project.project_id
  name                       = "spacelift-test"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = google_compute_network.spacelift-network.name
  subnetwork                 = google_compute_subnetwork.spacelift-subnet.name
  ip_range_pods              = "spacelift-pod-subnet"
  ip_range_services          = "spacelift-service-subnet"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-standard-2"
      node_locations            = "us-central1-b"
      min_count                 = 1
      max_count                 = 3
      local_ssd_count           = 0
      spot                      = true
      disk_size_gb              = 10
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      service_account           = google_service_account.node-pool.email
      preemptible               = false
      initial_node_count        = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
