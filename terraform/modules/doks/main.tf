terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

data "digitalocean_kubernetes_versions" "latest" {
  version_prefix = "1."
}

resource "digitalocean_kubernetes_cluster" "this" {
  name     = var.cluster_name
  region   = var.region
  version  = data.digitalocean_kubernetes_versions.latest.latest_version
  vpc_uuid = var.vpc_id

  node_pool {
    name       = "${var.cluster_name}-pool"
    size       = var.node_size
    node_count = var.node_count
    auto_scale = false
  }

  surge_upgrade    = false
  ha               = false
  maintenance_policy {
    day        = "sunday"
    start_time = "04:00"
  }
}
