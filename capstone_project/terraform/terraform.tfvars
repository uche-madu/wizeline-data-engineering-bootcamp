project_id       = "wizeline-deb"
region           = "us-central1"
zone             = "us-central1-c"
credentials_file = "../credentials.json"

# VPC
network_name = "deb-capstone-net"
subnet-01    = "deb-sub1"
subnet-02    = "deb-sub2"

# GKE
gke_cluster    = "deb-airflow-cluster"
node_pool_name = "deb-node-pool"
machine_type   = "n1-standard-2"
node_count     = 1

# Services
enable_apis                 = true
disable_services_on_destroy = false
disable_dependent_services  = false