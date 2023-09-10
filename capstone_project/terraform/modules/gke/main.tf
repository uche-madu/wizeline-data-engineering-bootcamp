resource "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster
  location = var.region
  project  = var.project_id

  node_pool {
    name         = var.node_pool_name
    node_count   = var.node_count
    machine_type = var.machine_type
  }
}