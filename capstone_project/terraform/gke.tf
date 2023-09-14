# google_client_config must be explicitly specified like the following.
data "google_client_config" "default" {}

# Retrieve the service account established in setup.sh
data "google_service_account" "deb-sa" {
  account_id = "deb-sa"
}

# Random input generator
resource "random_id" "suffix" {
  byte_length = 8
}

# GKE Settings
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 27.0.0"

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

# Helm Airflow
resource "helm_release" "airflow" {
  name             = "airflow"
  repository       = "https://airflow.apache.org"
  
  # Had to pull the helm chart via the CLI locally and reference 
  # the local directory ("./airflow") here because the Chart.yaml file in the 
  # remote repo was missing (probably a network issue)
  chart            = "./airflow" #"airflow"
  namespace        = "airflow"
  version          = var.airflow_helm_version
  create_namespace = true
  wait             = false # Setting to true would impair the wait-for-airflow-migrations container

  values = [file("${path.cwd}/airflow/dev-values.yaml"), local.rendered_values]

  depends_on = [module.gke.endpoint]

}
