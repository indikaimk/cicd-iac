terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "webapp-staging" {
  name   = "webapp-staging"
  region = "sgp1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.30.4-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3

    taint {
      key    = "workloadKind"
      value  = "database"
      effect = "NoSchedule"
    }
  }
}