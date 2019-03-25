resource "google_container_node_pool" "master-pool" {
  name    = "master-pool"
  zone    = "${local.zone}"
  cluster = "${google_container_cluster.primary.name}"

  initial_node_count = 2

  # this is here because of taints!
  provider = "google-beta"

  autoscaling {
    min_node_count = 5
    max_node_count = 6
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "false"
  }

  node_config {
    machine_type = "n1-standard-1"

    oauth_scopes = "${var.oauth_scopes}"

    labels {
      env = "prod"
    }

    #tags = ["foo", "bar"]
  }
}

resource "google_container_cluster" "primary" {
  name = "${var.cluster_name}"
  zone = "${local.zone}"

  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = "1.11.7-gke.12"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"

  network = "projects/${var.project}/global/networks/default"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }
}
