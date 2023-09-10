terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.81.0"
    }
  }

  backend "gcs" {
    bucket = "deb-capstone"
    prefix = "terraform/state"
  }
}

# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

data "google_service_account" "deb-sa" {
  account_id = "deb-sa"
}

# Random input generators
resource "random_id" "suffix" {
  byte_length = 8
}

# Services
module "cloudresourcemanager_service" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.3"

  project_id                  = var.project_id
  enable_apis                 = var.enable_apis
  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
  ]
}

module "services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.3"

  project_id                  = module.cloudresourcemanager_service.project_id
  enable_apis                 = var.enable_apis
  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

# VPC Settings
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.3"

  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name   = "deb-sub1"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    deb-sub1 = [
      {
        range_name    = "deb-sub1-secondary-gke-pods"
        ip_cidr_range = "10.10.11.0/24"
      },
      {
        range_name    = "deb-sub1-secondary-gke-services"
        ip_cidr_range = "10.10.21.0/24"
      },
    ]
  }
}

# GKE Settings
module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google"
  project_id        = module.vpc.project_id
  name              = "${var.gke_cluster}-${random_id.suffix.hex}"
  region            = var.region
  zones             = [var.zone]
  network           = module.vpc.network_name
  subnetwork        = module.vpc.subnets_names[0]
  ip_range_pods     = "deb-sub1-secondary-gke-pods"
  ip_range_services = "deb-sub1-secondary-gke-services"

  node_pools = [
    {
      name               = var.node_pool_name
      machine_type       = var.machine_type
      node_locations     = var.zone
      min_count          = 1
      max_count          = 2
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      service_account    = data.google_service_account.deb-sa.email
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
